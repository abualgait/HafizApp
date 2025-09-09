import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hafiz_app/core/config/api_config.dart';

class QfAuthService {
  final Dio _dio; // a lightweight Dio for token calls

  String? _accessToken;
  DateTime? _expiresAt;
  bool _refreshing = false;
  Completer<void>? _refreshCompleter;

  QfAuthService([Dio? dio]) : _dio = dio ?? Dio();

  bool get hasValidToken {
    if (_accessToken == null) return false;
    final now = DateTime.now().toUtc();
    // Refresh a bit before expiry to avoid race
    return _expiresAt != null &&
        now.isBefore(_expiresAt!.subtract(const Duration(seconds: 30)));
  }

  String? get accessToken => _accessToken;

  Future<void> ensureToken() async {
    if (hasValidToken) return;
    await _refreshToken();
  }

  Future<void> _refreshToken() async {
    if (_refreshing) {
      // Coalesce concurrent refreshes
      await (_refreshCompleter?.future);
      return;
    }
    _refreshing = true;
    _refreshCompleter = Completer<void>();
    try {
      final tokenUrl = '${ApiConfig.oauthBase}/token';
      final authHeader =
          'Basic ${base64Encode(utf8.encode('${ApiConfig.clientId}:${ApiConfig.clientSecret}'))}';
      final form = {
        'grant_type': 'client_credentials',
        if (ApiConfig.scope.isNotEmpty) 'scope': ApiConfig.scope,
      };
      final resp = await _dio.post(
        tokenUrl,
        data: FormData.fromMap(form),
        options: Options(
          headers: {
            'Authorization': authHeader,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          validateStatus: (_) => true,
        ),
      );
      if (resp.statusCode == 200) {
        final data = resp.data is Map
            ? Map<String, dynamic>.from(resp.data)
            : json.decode(resp.data as String);
        _accessToken = data['access_token'] as String?;
        final int expiresIn = (data['expires_in'] as num?)?.toInt() ?? 3600;
        _expiresAt = DateTime.now().toUtc().add(Duration(seconds: expiresIn));
      } else {
        throw DioException(
          requestOptions: resp.requestOptions,
          response: resp,
          type: DioExceptionType.badResponse,
          error: 'OAuth token request failed: ${resp.statusCode}',
        );
      }
    } finally {
      _refreshing = false;
      _refreshCompleter?.complete();
    }
  }
}

class QfAuthInterceptor extends Interceptor {
  final QfAuthService auth;

  QfAuthInterceptor(this.auth);

  bool _isQfHost(RequestOptions options) {
    final host = options.uri.host.toLowerCase();
    return host.endsWith('quran.foundation');
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isQfHost(options)) {
      try {
        await auth.ensureToken();
        final token = auth.accessToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {
        // Proceed without token if retrieval failed; server may still accept
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _isQfHost(err.requestOptions)) {
      try {
        await auth.ensureToken();
        final token = auth.accessToken;
        if (token != null && token.isNotEmpty) {
          final clone = await _retryWithToken(err.requestOptions, token);
          return handler.resolve(clone);
        }
      } catch (_) {}
    }
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retryWithToken(
      RequestOptions requestOptions, String token) async {
    final dio = Dio();
    // Copy base options
    dio.options = BaseOptions(
      baseUrl: requestOptions.baseUrl,
      connectTimeout: requestOptions.connectTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      validateStatus: (_) => true,
    );
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $token';
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        listFormat: requestOptions.listFormat,
      ),
    );
  }
}
