import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  // Membuat instance dari secure storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key yang akan digunakan untuk menyimpan token
  static const String _tokenKey = 'auth_token';

  // Fungsi untuk menyimpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Fungsi untuk mengambil token
  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Fungsi untuk menghapus token (untuk Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
