import 'package:mqtt_client/mqtt_client.dart';

abstract class MqttService {
  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates;

  Future<void> connect({
    String host,
    String clientId,
    int port,
  });

  void subscribe(String topic, {MqttQos qos});

  void disconnect();
}
