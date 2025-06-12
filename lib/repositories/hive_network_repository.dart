import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lab1/repositories/network_repository.dart';

class HiveNetworkService implements NetworkService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  HiveNetworkService() {
    _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      final connected = await isConnected();
      _controller.add(connected);
    });
  }

  @override
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onNetworkStatusChange => _controller.stream;
}
