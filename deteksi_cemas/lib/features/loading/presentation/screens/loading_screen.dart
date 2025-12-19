// ignore_for_file: unused_field

import 'dart:async';

import 'package:deteksi_cemas/features/onboarding/services/onboarding_services.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  // Gradient colors
  static const Color _colorPink = Color(0xFFff0f7b);
  static const Color _colorOrange = Color(0xFFf89b29);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 2)); // loading delay

    final completed = await OnboardingService.isCompleted();

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacementNamed(completed ? "/login" : "/onboarding");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [LoadingScreen._colorPink, LoadingScreen._colorOrange],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
            SizedBox(height: 20),
            const Text(
              "Deteksi Cemas",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
