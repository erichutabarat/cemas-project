import 'package:deteksi_cemas/features/auth/presentation/screens/register_screen.dart';
import 'package:deteksi_cemas/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF6AD8E0),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Deteksi Cemas",
      debugShowCheckedModeBanner: false,
      initialRoute: "/register",
      routes: {
        "/onboarding": (context) => OnboardingScreen(),
        "/register": (context) => RegisterScreen(),
      },
    );
  }
}
