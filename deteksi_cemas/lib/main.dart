import 'package:deteksi_cemas/features/auth/presentation/screens/login_screen.dart';
import 'package:deteksi_cemas/features/auth/presentation/screens/register_screen.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/auth_bloc.dart';
import 'package:deteksi_cemas/features/dashboard/dashboard_layout.dart';
import 'package:deteksi_cemas/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_survey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  runApp(BlocProvider(create: (context) => AuthBloc(), child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Deteksi Cemas",
      debugShowCheckedModeBanner: false,
      initialRoute: "/onboarding",
      routes: {
        "/onboarding": (context) => OnboardingScreen(),
        "/register": (context) => RegisterScreen(),
        "/login": (context) => LoginScreen(),
        "/dashboard": (context) => DashboardLayout(),
        "/hars_survey": (context) => HarsSurveyScreen(),
        "/hars_result": (context) => HarsResultScreen(),
      },
    );
  }
}
