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

  /// CONNECT SAFELY
  Future<void> connect() async {
    if (_client != null &&
        _client!.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }

    _client = MqttServerClient(_broker, _clientId);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.logging(on: false);

    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    await _client!.connect();
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

        if (payload == 'ONLINE') {
          if (!completer.isCompleted) {
            completer.complete(true);
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
