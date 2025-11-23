// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:deteksi_cemas/features/dashboard/presentation/widgets/heartbeat_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  final ScrollController? controller;
  const RecordScreen({super.key, this.controller});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final bool _deviceConnected = true;
  late RecordStatus _recordStatus = RecordStatus.idle;

  // State variables
  Timer? _timer;
  int _secondsElapsed = 0; // Total seconds since the counter started
  bool _isRunning = false; // Flag to indicate if the timer is currently running

  final GlobalKey<HeartbeatAnimationState> _heartbeatKey =
      GlobalKey<HeartbeatAnimationState>();

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        // decoration: BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              // Record Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.info_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          "Record Heartbeat",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "No Device Connected",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
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
                            Icons.settings_suggest_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36),

              // IoT Device Status
              Text(
                _deviceConnected
                    ? "Ready to record Heartbeat"
                    : "No Device Connected",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _deviceConnected ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 16),

              // Heartbeat animation
              HeartbeatAnimation(key: _heartbeatKey),
              SizedBox(height: 16),

              // Record Button
              GestureDetector(
                onTap: () {
                  _startRecording(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
              SizedBox(height: 16),

              Text(
                _formatTime(_secondsElapsed),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 26),

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
                      Padding(
                        padding: const EdgeInsets.only(
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

                      // --- FIX IS APPLIED HERE ---
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align content to the top
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
                                  Text(
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
          padding: const EdgeInsets.all(0),
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
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
        SnackBar(
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

          //TODO: call machine learning here
        }
        state.toggleAnimation();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Heartbeat animation error")));
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
}

enum RecordStatus { idle, recording, recorded, sent }
