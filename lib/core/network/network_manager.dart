import 'package:dio/dio.dart';

abstract class NetworkManagerI {
  Future<Response> get(String url, {Map<String, dynamic>? params});

  Future<Response> post(String url, {Map<String, dynamic>? data});

  Future<Response> put(String url, {Map<String, dynamic>? data});

  Future<Response> delete(String url, {Map<String, dynamic>? data});
}

class NetworkManagerImpl extends NetworkManagerI {
  final Dio _dio;

  NetworkManagerImpl(this._dio);

  @override
  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response;
    } catch (error) {
      throw Exception('Error making GET request: $error');
    }
  }

  @override
  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (error) {
      throw Exception('Error making POST request: $error');
    }
  }

  @override
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } catch (error) {
      throw Exception('Error making PUT request: $error');
    }
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response;
    } catch (error) {
      throw Exception('Error making DELETE request: $error');
    }
  }
}
