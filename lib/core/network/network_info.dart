import 'package:connectivity_plus/connectivity_plus.dart';

// For checking internet connectivity
abstract class NetworkInfoI {
  Future<bool> isConnected();

  // Latest connectivity_plus returns a list of results (multi-interface).
  Future<List<ConnectivityResult>> get connectivityResult;

  // Latest connectivity_plus emits a list of results.
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  Connectivity connectivity;

  NetworkInfo(this.connectivity);

  ///checks internet is connected or not
  ///returns [true] if internet is connected
  ///else it will return [false]
  @override
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    // Consider connected if any interface reports connectivity.
    return results.any((r) => r != ConnectivityResult.none);
  }

  // to check type of internet connectivity
  @override
  Future<List<ConnectivityResult>> get connectivityResult async =>
      connectivity.checkConnectivity();

  //check the type on internet connection on changed of internet connection
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}
