// lib/repositories/mqtt_service.dart
import 'package:lab1/repositories/mqtt_service.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HiveMqttService implements MqttService {
  late final MqttServerClient _client;
  final logger = Logger();

  @override
  /// Публічний стрім повідомлень від брокера
  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates =>
      _client.updates!;

  @override
  /// Підключається до брокера
  Future<void> connect({
    String host = 'broker.hivemq.com',
    String clientId = 'flutter_client_id',
    int port = 1883,
  }) async {
    _client = MqttServerClient(host, clientId)
      ..port = port
      ..logging(on: false)
      ..keepAlivePeriod = 20
      // призначаємо поле onDisconnected функцією
      ..onDisconnected = () {
        logger.w('Disconnected');
      }
      // призначаємо поле onConnected функцією
      ..onConnected = () {
        logger.w('Connected');
      };

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } catch (e) {
      logger.w('Connection failed: $e');
      _client.disconnect();
      rethrow;
    }
  }

  @override
  /// Підписка на топік
  void subscribe(String topic, {MqttQos qos = MqttQos.atMostOnce}) {
    _client.subscribe(topic, qos);
  }

  @override
  /// Відключитися
  void disconnect() {
    _client.disconnect();
  }
}
