// ignore_for_file: avoid_print

import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// Note: We use this conditional import to prevent Android from crashing
import 'package:mqtt_client/mqtt_browser_client.dart'
    if (dart.library.io) 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  static const String _broker = '103.63.25.67';
  static const String _clientId = 'flutter_checker';

  // Using dynamic here avoids the "Type Mismatch" errors between Server/Browser
  dynamic _client;

  MqttService._internal();

  void _publish(String topic, String message) {
    if (_client == null ||
        _client!.connectionStatus?.state != MqttConnectionState.connected) {
      print("Cannot publish: MQTT not connected");
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void sendConnectHandshake(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'CONNECT');
  void startRecording(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'START');
  void stopRecording(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'STOP');
  void sendAuthToken(String deviceId, String token) =>
      _publish('esp32/device_$deviceId/auth', token);

  Future<void> connect() async {
    if (_client != null &&
        _client!.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }

    if (kIsWeb) {
      // WEB CONFIG: Uses the browser client
      final browserClient = MqttBrowserClient(
        'wss://deteksicemas.my.id/mqtt/',
        _clientId,
      );
      browserClient.port = 443;
      _client = browserClient;
    } else {
      // MOBILE CONFIG: Uses the server client
      final serverClient = MqttServerClient(_broker, _clientId);
      serverClient.port = 8083;
      serverClient.useWebSocket = false;
      _client = serverClient;
    }

    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = () => print('Disconnected');
    _client!.onConnected = () => print('Connected to Broker');

    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      print('Connecting (Web: $kIsWeb)...');
      await _client!.connect();
    } catch (e) {
      print('MQTT Exception: $e');
      disconnect();
    }
  }

  Future<bool> checkDeviceExist(
    String deviceId, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_client == null ||
        _client!.connectionStatus?.state != MqttConnectionState.connected) {
      return false;
    }

    final topic = 'esp32/device_$deviceId/status';
    final completer = Completer<bool>();
    _client!.subscribe(topic, MqttQos.atLeastOnce);

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      for (final event in events) {
        final msg = event.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          msg.payload.message,
        );
        if (['IDLE', 'USED', 'RECORDING_STARTED'].contains(payload)) {
          if (!completer.isCompleted) completer.complete(true);
        }
      }
    });

    Future.delayed(timeout, () {
      if (!completer.isCompleted) completer.complete(false);
    });
    return completer.future;
  }

  void disconnect() {
    _client?.disconnect();
    _client = null;
  }
}
