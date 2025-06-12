// lib/widget/sensor.dart
import 'package:flutter/material.dart';
import 'package:lab1/repositories/hive_mqtt_service.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});
  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final mqtt = HiveMqttService();
  final logger = Logger();
  String message = 'Даних ще немає';

  @override
  void initState() {
    super.initState();

    mqtt
        .connect()
        .then((_) {
          mqtt.subscribe('sensor/temperature');
          mqtt.updates.listen((events) {
            final recMess = events[0].payload as MqttPublishMessage;
            final payload = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message,
            );
            setState(() {
              message = payload;
            });
          });
        })
        .catchError((Object e) {
          logger.w('Error while connecting to MQTT: $e');
        });
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MQTT Сенсор')),
      body: Center(child: Text('Температура: $message')),
    );
  }
}
