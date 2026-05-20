import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String broker, String clientId) {
  final client = MqttServerClient(broker, clientId);
  client.port = 8083;
  client.useWebSocket = false;
  return client;
}
