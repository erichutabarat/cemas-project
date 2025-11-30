import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _apiUrl = dotenv.env['BACKEND_URL'] ?? "http://localhost:8080";
  final String _loginEndpoint = "/api/auth/login";
  // Fungsi yang memanggil API Login
  Future<List<String>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(_apiUrl + _loginEndpoint),
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
}
