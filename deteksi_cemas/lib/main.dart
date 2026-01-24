import 'package:deteksi_cemas/features/auth/domain/repository/auth_repository.dart';
import 'package:deteksi_cemas/features/auth/presentation/screens/login_screen.dart';
import 'package:deteksi_cemas/features/auth/presentation/screens/register_screen.dart';
import 'package:deteksi_cemas/features/auth/presentation/states/auth_bloc.dart';
import 'package:deteksi_cemas/features/dashboard/dashboard_layout.dart';
import 'package:deteksi_cemas/features/loading/presentation/screens/loading_screen.dart';
import 'package:deteksi_cemas/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_survey_screen.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/language/localecubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF6AD8E0),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    // Use MultiBlocProvider to provide both Blocs at the top level
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(create: (context) => LocaleCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Now BlocBuilder can find LocaleCubit because it's provided in MultiBlocProvider
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          title: "Deteksi Cemas",
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: "/loading",
          routes: {
            "/loading": (context) => const LoadingScreen(),
            "/onboarding": (context) => OnboardingScreen(),
            "/register": (context) => RegisterScreen(),
            "/login": (context) => LoginScreen(),
            "/dashboard": (context) => DashboardLayout(),
            "/hars_survey": (context) => HarsSurveyScreen(),
            "/hars_result": (context) => HarsResultScreen(),
          },
        );
      },
    );
  }
}
