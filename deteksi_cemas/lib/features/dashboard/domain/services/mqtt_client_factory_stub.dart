import 'package:mqtt_client/mqtt_client.dart';

MqttClient createMqttClient(String broker, String clientId) {
  throw UnsupportedError('No MQTT client for this platform');
}
