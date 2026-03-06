import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  // Logic specifically for Mobile
  final client = MqttServerClient(broker, clientId);
  client.port = 8083;
  client.useWebSocket = false;
  return client;
}
