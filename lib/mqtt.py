import paho.mqtt.publish as publish
publish.single("sensor/temperature", "25.2", hostname="test.mosquitto.org")

