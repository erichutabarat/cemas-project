// ignore_for_file: avoid_print

import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  static const String _broker = '103.63.25.67';
  static const String _clientId = 'flutter_checker';

  MqttServerClient? _client;

  MqttService._internal();

  /// --- NEW: PRIVATE HELPER FOR PUBLISHING ---
  void _publish(String topic, String message) {
    if (_client == null ||
        _client!.connectionStatus?.state != MqttConnectionState.connected) {
      print("Cannot publish: MQTT not connected");
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print("Published [$message] to $topic");
  }

  /// --- NEW: SEND CONNECT HANDSHAKE ---
  /// Call this when the user enters the recording screen to set status to "USED"
  void sendConnectHandshake(String deviceId) {
    final topic = 'esp32/device_$deviceId/control';
    _publish(topic, 'CONNECT');
  }

  /// --- NEW: START RECORDING ---
  void startRecording(String deviceId) {
    final topic = 'esp32/device_$deviceId/control';
    _publish(topic, 'START');
  }

  /// --- NEW: STOP RECORDING ---
  void stopRecording(String deviceId) {
    final topic = 'esp32/device_$deviceId/control';
    _publish(topic, 'STOP');
  }

  /// --- NEW: SEND AUTH TOKEN ---
  /// Call this so the ESP32 knows which token to use for the upload
  void sendAuthToken(String deviceId, String token) {
    final topic = 'esp32/device_$deviceId/auth';
    _publish(topic, token); // Usually includes "Bearer "
  }

  /// CONNECT SAFELY
  Future<void> connect() async {
    if (_client != null &&
        _client!.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }

    _client = MqttServerClient(_broker, _clientId);
    _client!.port = 8083;
    _client!.keepAlivePeriod = 20;

    // debug topics:
    _client!.onDisconnected = () => print('Disconnected');
    _client!.onConnected = () => print('Connected to Broker');
    _client!.onSubscribed = (topic) => print('Subscribed to $topic');

    // CRITICAL: Ensure the protocol is correct
    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean() // This is important for "check" functionality
        .withWillQos(MqttQos.atLeastOnce);

    try {
      print('Connecting to $_broker...');
      await _client!.connect();
    } catch (e) {
      print('Exception: $e');
      disconnect();
    }
  }

  /// 🔍 CHECK DEVICE EXIST
  Future<bool> checkDeviceExist(
    String deviceId, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_client == null ||
        _client!.connectionStatus?.state != MqttConnectionState.connected) {
      throw Exception('MQTT not connected');
    }

    final topic = 'esp32/device_$deviceId/status';
    final completer = Completer<bool>();

    _client!.subscribe(topic, MqttQos.atLeastOnce);

    late StreamSubscription sub;
    sub = _client!.updates!.listen((events) {
      for (final event in events) {
        final msg = event.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          msg.payload.message,
        );

        if (payload == 'IDLE' ||
            payload == 'USED' ||
            payload == 'RECORDING_STARTED') {
          if (!completer.isCompleted) {
            if (!completer.isCompleted) {
              completer.complete(
                true,
              ); // The device exists and is reporting a state
            }
          }
          _client!.unsubscribe(topic);
          sub.cancel();
        }
      }
    });

    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
        _client!.unsubscribe(topic);
        sub.cancel();
      }
    });

    return completer.future;
  }

  void disconnect() {
    _client?.disconnect();
    _client = null;
  }
}
