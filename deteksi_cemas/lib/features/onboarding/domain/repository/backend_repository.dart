import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendRepository {
  static const String _key = 'backend_base_url';

  /// Saves the custom URL to phone storage
  static Future<void> setUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, url);
  }

  /// Gets the URL. Returns null if not set yet.
  static Future<String?> getUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<String> getBackendUrl() async {
    final String dotenvUrl = dotenv.env['BACKEND_URL'] ?? "";
    return dotenvUrl;
  }
}
