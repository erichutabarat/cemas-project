import 'dart:convert';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyEmail = 'remembered_email';
  final String _loginEndpoint = "/api/auth/login";
  // Fungsi yang memanggil API Login
  Future<List<String>> loginUser(String email, String password) async {
    final String apiUrl = await BackendRepository.getBackendUrl();
    final response = await http.post(
      Uri.parse('$apiUrl$_loginEndpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Login Sukses. Kembalikan token (atau pesan sukses).
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      String name = responseData['name'];

      // Mengembalikan token (yang akan digunakan BLoC untuk menentukan sukses)
      return [token, name];
    } else if (response.statusCode == 401) {
      // Gagal karena kredensial salah (Unauthorized)
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? "Email atau password salah.");
    } else {
      // Gagal karena error server lain
      throw Exception("Gagal login: Status ${response.statusCode}");
    }
  }

  static Future<void> rememberEmail(String email) async {
    // Simpan email ke penyimpanan lokal atau preferensi pengguna
    // Implementasi spesifik tergantung pada kebutuhan aplikasi Anda
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);

    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }
}
