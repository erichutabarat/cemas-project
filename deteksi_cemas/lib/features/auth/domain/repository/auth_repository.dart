import 'dart:convert';
import 'package:deteksi_cemas/features/auth/presentation/states/googleauth_result.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keyEmail = 'remembered_email';
  final String _loginEndpoint = "/api/auth/login";
  final String _registerEndpoint = "/api/auth/register";

  // Login by google
  final String _googleEndpoint = "/api/auth/google-login";
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Use your WEB CLIENT ID here, not the Android one
    clientId:
        '828195486741-fgsu0a94ejkgloej50qcn3qjj3fbg4kg.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

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

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required DateTime birthDate,
    required String gender,
  }) async {
    final String apiUrl = await BackendRepository.getBackendUrl();
    final String formattedDate =
        "${birthDate.toIso8601String().split('.')[0]}Z";

    final response = await http.post(
      Uri.parse('$apiUrl$_registerEndpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'birthdate': formattedDate,
        'gender': gender.toLowerCase(),
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Matches your success JSON: {"message": "...", "name": "...", "user_id": ...}
      return responseData;
      // Inside registerUser method in AuthRepository
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String details = responseData['details'] ?? "";
      String error = responseData['error'] ?? "";

      // Check if the technical error is related to Password length
      if (details.contains("Password") && details.contains("'min' tag")) {
        throw Exception("password_too_short"); // Unique key for the Bloc
      }

      // Fallback to the generic error or details
      throw Exception(details.isNotEmpty ? details : error);
    }
  }

  // Google Sign-In
  Future<GoogleAuthResult> signInWithGoogle() async {
    try {
      // 1. Force Account Selection
      // This clears previous sessions so the "Choose an account" popup always appears.
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Sign-in dibatalkan.");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) throw Exception("ID Token null.");

      final String apiUrl = await BackendRepository.getBackendUrl();

      final response = await http.post(
        Uri.parse('$apiUrl$_googleEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        bool isRegistered = data['registered'] ?? false;

        return GoogleAuthResult(
          isRegistered: isRegistered,
          // name: Check backend first -> then google name -> then fallback to "User"
          name: data['name'] ?? googleUser.displayName ?? "User",

          // email: Check backend first -> then google email -> then fallback to empty string
          email: data['email'] ?? googleUser.email ?? "",

          token:
              data['token'], // This can stay nullable if your class allows it
        );
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
          errorData['error'] ?? "Server Error ${response.statusCode}",
        );
      }
    } catch (e) {
      // Catching the error here lets you see exactly what failed in the logs
      debugPrint("Google Auth Error: $e");
      rethrow;
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
