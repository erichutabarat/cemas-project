import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  static Future<void> setCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }
}
