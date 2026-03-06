import 'package:mqtt_client/mqtt_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  throw UnsupportedError('Cannot create a client without dart:html or dart:io');
}
