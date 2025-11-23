import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeartbeatAnimation extends StatefulWidget {
  const HeartbeatAnimation({super.key});

  @override
  State<HeartbeatAnimation> createState() => HeartbeatAnimationState();
}

class HeartbeatAnimationState extends State<HeartbeatAnimation>
    with SingleTickerProviderStateMixin {
  // 1. Add Ticker Mixin

  // 2. Declare the AnimationController
  late AnimationController _controller;
  bool playAnimationStatus =
      false; // Use true initially if you want it to start playing

  @override
  void initState() {
    super.initState();

    // 3. Initialize the controller
    _controller = AnimationController(
      vsync: this, // Assign the Ticker
      duration: const Duration(
        seconds: 2,
      ), // Set a default duration (or get it from Lottie)
    );

    // Start playing immediately and repeat
    _controller.stop();
  }

  @override
  void dispose() {
    // Dispose the controller to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    setState(() {
      playAnimationStatus = !playAnimationStatus;

      if (playAnimationStatus) {
        // If status is now true, play/repeat the animation
        _controller.repeat();
      } else {
        // If status is now false, pause the animation
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 4. Use Lottie.asset and pass the controller
        Lottie.asset(
          'assets/animation/heartbeat_animation.json',
          controller: _controller, // Pass the controller here
          height: 250,
          width: 250,
          // Optional: automatically set the controller duration once loaded
          onLoaded: (composition) {
            if (_controller.duration == null) {
              _controller.duration = composition.duration;
              _controller.repeat(); // Re-start repeat after duration is set
            }
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
