abstract class NetworkService {
  Future<bool> isConnected();
  Stream<bool> get onNetworkStatusChange;
}
