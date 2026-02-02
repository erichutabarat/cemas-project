// ignore_for_file: unused_field

import 'dart:async';
import 'package:deteksi_cemas/features/onboarding/services/onboarding_services.dart';
import 'package:deteksi_cemas/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  static const Color _colorPink = Color(0xFFff0f7b);
  static const Color _colorOrange = Color(0xFFf89b29);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // app theme
  final AppTheme _appTheme = AppTheme();
  // app version
  final String _appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    // Keep it for at least 3 seconds for a better feel
    await Future.delayed(const Duration(seconds: 3));

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
        decoration: BoxDecoration(gradient: AppTheme.softChillReversed),
        child: SafeArea(
          // Ensures content doesn't hit the notch/bottom bar
          child: Column(
            children: [
              const Spacer(flex: 3), // Pushes content down
              // --- Middle Section: Logo & Loader ---
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                "DETEKSI CEMAS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),

              const Spacer(flex: 2), // Pushes slogan/version to the bottom
              // --- Bottom Section: Slogan & Version ---
              const Text(
                "Understand yourself, calm your mind.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "v$_appVersion", // Manual version or use package_info_plus
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
