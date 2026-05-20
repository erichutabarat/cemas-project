// ignore_for_file: avoid_print
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_client_factory.dart'; // ← your 4 new files

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;

  static const String _broker = '103.63.25.67';
  static const String _clientId = 'flutter_checker';

  MqttClient? _client; // ← now typed properly, no more dynamic

  MqttService._internal();

  // ─── Private Helpers ──────────────────────────────────────────────────────

  bool get _isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  void _publish(String topic, String message) {
    if (!_isConnected) {
      print("Cannot publish: MQTT not connected");
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // ─── Public Control Methods ───────────────────────────────────────────────

  void sendConnectHandshake(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'CONNECT');

  void startRecording(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'START');

  void stopRecording(String deviceId) =>
      _publish('esp32/device_$deviceId/control', 'STOP');

  void sendAuthToken(String deviceId, String token) =>
      _publish('esp32/device_$deviceId/auth', token);

  // ─── Connection ───────────────────────────────────────────────────────────

  Future<void> connect() async {
    if (_isConnected) return;

    // Factory handles Web vs Mobile — no kIsWeb needed here anymore
    _client = createMqttClient(_broker, _clientId);

    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = () => print('Disconnected');
    _client!.onConnected = () => print('Connected to Broker');
    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    try {
      print('Connecting...');
      await _client!.connect();
    } catch (e) {
      print('MQTT Exception: $e');
      disconnect();
    }
  }

  // ─── Device Check ─────────────────────────────────────────────────────────

  Future<bool> checkDeviceExist(
    String deviceId, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (!_isConnected) return false;

    final topic = 'esp32/device_$deviceId/status';
    final completer = Completer<bool>();

    _client!.subscribe(topic, MqttQos.atLeastOnce);

    final sub = _client!.updates!.listen((
      List<MqttReceivedMessage<MqttMessage>> events,
    ) {
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

    final result = await completer.future;
    await sub.cancel(); // ← cancel listener after done to avoid leaks
    _client!.unsubscribe(topic); // ← clean up the subscription too
    return result;
  }

  // ─── Disconnect ───────────────────────────────────────────────────────────

  void disconnect() {
    _client?.disconnect();
    _client = null;
  }
}
