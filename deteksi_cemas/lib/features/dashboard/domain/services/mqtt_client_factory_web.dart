import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient createMqttClient(String broker, String clientId) {
  final client = MqttBrowserClient('wss://deteksicemas.my.id/mqtt/', broker);
  client.port = 443;
  return client;
}
