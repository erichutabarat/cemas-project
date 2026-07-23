import 'package:flutter/material.dart';

class HeartbeatAnimation extends StatefulWidget {
  const HeartbeatAnimation({super.key});

  @override
  State<HeartbeatAnimation> createState() => HeartbeatAnimationState();
}

class HeartbeatAnimationState extends State<HeartbeatAnimation>
    with SingleTickerProviderStateMixin {
  // 1. Declare the AnimationController and a scale animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool playAnimationStatus = false;

  @override
  void initState() {
    super.initState();

    // 2. Initialize the controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ), // Adjust speed of heartbeat here
    );

    // 3. Define the scale range (e.g., from normal size 1.0 to 1.25 times bigger)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Stop initially
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    setState(() {
      playAnimationStatus = !playAnimationStatus;

      if (playAnimationStatus) {
        // Play and reverse back to create a smooth pulsing heartbeat effect
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset(); // Optional: reset to original size when stopped
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 4. Use ScaleTransition with Image.asset instead of Lottie
        ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            'assets/images/heartbeat_image.png',
            height: 150,
            width: 150,
          ),
        ),

        const SizedBox(height: 20),

        // Optional toggle button to test the animation state
        ElevatedButton(
          onPressed: toggleAnimation,
          child: Text(playAnimationStatus ? 'Stop' : 'Play'),
        ),
      ],
    );
  }
}
