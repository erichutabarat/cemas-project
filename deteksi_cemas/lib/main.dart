import 'package:deteksi_cemas/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Deteksi Cemas",
      debugShowCheckedModeBanner: false,
      initialRoute: "/onboarding",
      routes: {"/onboarding": (context) => OnboardingScreen()},
    );
  }
}
