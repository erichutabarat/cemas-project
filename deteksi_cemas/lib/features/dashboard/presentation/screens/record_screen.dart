// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:deteksi_cemas/features/dashboard/domain/repository/heartbeat_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/heartbeat_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  final ScrollController? controller;
  final void Function() backtohome;
  const RecordScreen({super.key, this.controller, required this.backtohome});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // CHANGED: Made non-final so we can update it from the bottom sheet
  final HeartbeatRepository _heartbeatRepository = HeartbeatRepository();

  bool _deviceConnected = false;
  late RecordStatus _recordStatus = RecordStatus.idle;
  int? _currentDeviceId; // Changed to nullable int for initial state

  // State variables
  Timer? _timer;
  int _secondsElapsed = 0; // Total seconds since the counter started
  bool _isRunning = false; // Flag to indicate if the timer is currently running

  // Send and analyze heartbeat data
  String analyzeState = "idle";
  int? inspectionId;

  final GlobalKey<HeartbeatAnimationState> _heartbeatKey =
      GlobalKey<HeartbeatAnimationState>();

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // --- NEW: Handler to receive data from the bottom sheet ---
  void _handleDeviceSave(String deviceId) {
    setState(() {
      // Assuming a simple connection logic here: if ID is non-empty, device is "connected"
      _deviceConnected = deviceId.isNotEmpty;
      // Convert ID to int, handle potential failure if necessary
      _currentDeviceId = int.tryParse(deviceId) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        // decoration: BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              // Record Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.backtohome,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        const Text(
                          "Record Heartbeat",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          !_deviceConnected
                              ? "No Device Connected"
                              : "Device ID: $_currentDeviceId", // Show connected ID
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) => GestureDetector(
                        // The Builder provides the working 'context'
                        onTap: () {
                          if (kDebugMode) {
                            print("test: Opening EndDrawer");
                          }
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // IoT Device Status
              if (!_deviceConnected)
                Column(
                  children: [
                    const Text(
                      "No Device Connected",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    // CRITICAL CHANGE: Pass the handler to the bottom sheet function
                    ElevatedButton.icon(
                      // The onPressed callback is clean: it just calls the helper function
                      onPressed: () =>
                          _showBottomSheet(context, _handleDeviceSave),
                      icon: const Icon(Icons.arrow_upward),
                      label: const Text(
                        'Set Device ID',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_deviceConnected)
                const Column(
                  children: [
                    Text(
                      "Device Connected, Ready to record!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Heartbeat animation
              HeartbeatAnimation(key: _heartbeatKey),
              const SizedBox(height: 16),

              // Record Button
              GestureDetector(
                onTap: () {
                  _startRecording(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    (_recordStatus == RecordStatus.idle)
                        ? Icons.play_circle_filled_rounded
                        : (_recordStatus == RecordStatus.recording)
                        ? Icons.pause_circle_filled_rounded
                        : (_recordStatus == RecordStatus.recorded)
                        ? Icons.stop_circle_rounded
                        : Icons.check_circle_rounded,
                    color: _recordStatus == RecordStatus.sent
                        ? Colors.green
                        : Colors.red,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                _formatTime(_secondsElapsed),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 26),

              // Record Heartbeat alternative
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade400,
                  ),
                  child: Column(
                    children: [
                      // Header Text
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                        ), // Add padding for separation
                        child: Text(
                          "Don't have IoT Device?",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align content to the top
                        children: [
                          // 1. Image takes a flexible portion of the space
                          Expanded(
                            flex: 4, // Give the image 4 parts of the space
                            child: Image.asset(
                              "assets/images/onboarding_survey.png",
                              height:
                                  180, // Reduced height slightly to fit better
                              fit: BoxFit.contain,
                            ),
                          ),

                          // 2. Text and Button take the remaining flexible space
                          Expanded(
                            flex:
                                5, // Give the text column 5 parts of the space (slightly more)
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                children: [
                                  const Text(
                                    "You can use this survey to detect your anxiety level by filling HARS survey",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ), // Added color for visibility
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Start Survey"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // --------------------------
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets
              .zero, // Use EdgeInsets.zero instead of const EdgeInsets.all(0)
          children: [
            // Header
            Container(
              height: 120,
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: Text(
                  'Record Screen Help',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Section 1: How to Record
            ListTile(
              title: const Text('1. How to Record'),
              subtitle: const Text(
                'First, ensure your IoT device is connected. Then, use the central "Play/Pause" button to control data collection.',
              ),
              leading: Icon(
                Icons.mic_none,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Divider(),
            // Section 2: Device ID Setup (Actionable Info)
            ListTile(
              title: const Text('2. IoT Device Setup'),
              subtitle: const Text(
                'You must enter your unique IoT Device ID to start streaming data. Tap the "Set Device ID" button on the main screen.',
              ),
              leading: Icon(
                Icons.qr_code_scanner,
                color: Theme.of(context).primaryColor,
              ),
            ),
            // Section 3: Alternative Method
            const Divider(),
            ListTile(
              title: const Text('3. What if I don\'t have a device?'),
              subtitle: const Text(
                'If you don\'t have an IoT device, you can use the built-in HARS Survey (Hamilton Anxiety Rating Scale) to manually assess your anxiety.',
              ),
              leading: Icon(
                Icons.question_answer_outlined,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startRecording(BuildContext context) {
    if (kDebugMode) {
      print(_recordStatus);
    }
    if (!_deviceConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Can't play without IOT Device connected and ready"),
        ),
      );
    } else {
      final state = _heartbeatKey.currentState;
      if (state != null) {
        if (_recordStatus == RecordStatus.idle) {
          setState(() {
            _recordStatus = RecordStatus.recording;
            _startStopwatch();
          });
        } else if (_recordStatus == RecordStatus.recording) {
          setState(() {
            _recordStatus = RecordStatus.recorded;
            _pauseStopwatch(); // <<< PAUSE STOPWATCH (or stop/reset, depending on your flow)
          });
        } else if (_recordStatus == RecordStatus.recorded) {
          setState(() {
            _recordStatus = RecordStatus.sent;
            _resetStopwatch();
          });
          showFullModal(context);
        }
        state.toggleAnimation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Heartbeat animation error")),
        );
      }
    }
  }

  // Function to start or resume the stopwatch
  void _startStopwatch() {
    if (_isRunning) return; // Already running, do nothing

    _isRunning = true;

    // Creates a periodic timer that calls the callback every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++; // Increment the counter
      });
    });
  }

  // Function to pause the stopwatch
  void _pauseStopwatch() {
    if (!_isRunning) return; // Already paused, do nothing

    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // Function to reset the stopwatch
  void _resetStopwatch() {
    _timer?.cancel();
    setState(() {
      _secondsElapsed = 0;
      _isRunning = false;
    });
  }

  // Function to format the elapsed time into a readable string (MM:SS)
  String _formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = (seconds % 60);

    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (remainingSeconds < 10)
        ? '0$remainingSeconds'
        : '$remainingSeconds';

    return '$minutesStr:$secondsStr';
  }

  // --- MODIFIED _showBottomSheet FUNCTION ---
  // Now accepts a callback function to send the data back to the parent state
  void _showBottomSheet(BuildContext context, void Function(String id) onSave) {
    // Calling the Flutter function to show a modal overlay from the bottom
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled:
          true, // IMPORTANT: Needed to handle keyboard pushing up the sheet
      // Optional: Add a nice rounded shape to the top corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // The builder function returns the widget that will be inside the sheet
      builder: (BuildContext sheetContext) {
        // Use Padding to ensure the sheet is pushed up by the keyboard
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          // Use the dedicated StatefulWidget for the sheet content
          child: _IotIdSetupSheet(onSave: onSave),
        );
      },
    );
  }

  void showFullModal(BuildContext context) {
    late String analyzeState = "recorded";
    if (analyzeState == "recorded") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Recording Complete'),
            content: const Text(
              'Your heartbeat audio has been saved successfully.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Analyze Now'),
                onPressed: () {
                  // use sample audio file for testing upload
                  _heartbeatRepository
                      .uploadHeartbeatData("assets/audio/heartbeat_sample.wav")
                      .then((response) {
                        if (kDebugMode) {
                          print('Upload successful: ${response.message}');
                        }
                        if (kDebugMode) {
                          print('Inspection id: ${response.inspectionId}');
                        }
                        analyzeState = "sent";
                      })
                      .catchError((error) {
                        if (kDebugMode) {
                          print('Upload failed: $error');
                        }
                      });
                },
              ),
            ],
          );
        },
      );
    } else if (analyzeState == "sent") {
      // use websocket to check analysis result
    }
  }
}

enum RecordStatus { idle, recording, recorded, sent }

enum IoTDeviceCheckStatus { idle, checking, ready, failed }

// --- NEW HELPER WIDGET FOR SHEET CONTENT ---
// This StatefulWidget manages the input state and buttons within the modal sheet.

class _IotIdSetupSheet extends StatefulWidget {
  final void Function(String id) onSave;

  const _IotIdSetupSheet({required this.onSave});

  @override
  State<_IotIdSetupSheet> createState() => _IotIdSetupSheetState();
}

class _IotIdSetupSheetState extends State<_IotIdSetupSheet> {
  final TextEditingController _idController = TextEditingController();
  String _currentDeviceId = '';
  late IoTDeviceCheckStatus _iotcheckstatus = IoTDeviceCheckStatus.idle;
  @override
  void initState() {
    super.initState();
    _idController.addListener(_updateDeviceId);
  }

  @override
  void dispose() {
    _idController.removeListener(_updateDeviceId);
    _idController.dispose();
    super.dispose();
  }

  void _updateDeviceId() {
    setState(() {
      _currentDeviceId = _idController.text;
    });
  }

  Future<void> _onCheck(BuildContext context) async {
    // Changed to Future<void> and added async
    if (kDebugMode) {
      print('Checking ID: $_currentDeviceId');
    }

    // 1. Set status to checking
    setState(() {
      _iotcheckstatus = IoTDeviceCheckStatus.checking;
    });

    // 2. Introduce the delay (simulating a network request)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 3. Set status to ready (or failed) after delay
    setState(() {
      _iotcheckstatus = IoTDeviceCheckStatus.ready;
    });

    // Show final status message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device Check Complete! Status: Ready.'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _onSave() {
    // REQUIREMENT: Save function
    if (kDebugMode) {
      print('Saving ID: $_currentDeviceId');
    }

    // 1. Pass data back to the parent RecordScreen using the callback
    widget.onSave(_currentDeviceId);

    // 2. Close the bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeviceIdValid = _currentDeviceId.isNotEmpty;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: Column(
        // Use MainAxisSize.min to ensure the sheet only takes the necessary height
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Setup IoT Device ID',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Input Field for IoT ID
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Enter Device ID (e.g., 1234)',
              hintText: 'Should be numeric',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.wifi_tethering),
            ),
            keyboardType: TextInputType.number, // Suggest numeric input for IDs
          ),
          const SizedBox(height: 14),

          Text(
            _iotcheckstatus == IoTDeviceCheckStatus.idle
                ? ""
                : _iotcheckstatus == IoTDeviceCheckStatus.checking
                ? "Checking..."
                : _iotcheckstatus == IoTDeviceCheckStatus.ready
                ? "Ready"
                : "Failed",
            style: TextStyle(
              fontSize: 16,
              color: (_iotcheckstatus == IoTDeviceCheckStatus.ready
                  ? Colors.green
                  : Colors.red),
            ),
          ),
          const SizedBox(height: 14),
          // Buttons Row
          Row(
            children: [
              // CHECK Button
              Expanded(
                child: OutlinedButton(
                  onPressed: isDeviceIdValid ? () => _onCheck(context) : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Check'),
                ),
              ),
              const SizedBox(width: 16),

              // SAVE Button
              Expanded(
                child: ElevatedButton(
                  onPressed: isDeviceIdValid ? _onSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
