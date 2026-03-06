import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  // Logic specifically for Web
  final client = MqttBrowserClient('wss://deteksicemas.my.id/mqtt/', clientId);
  client.port = 443;
  return client;
}
