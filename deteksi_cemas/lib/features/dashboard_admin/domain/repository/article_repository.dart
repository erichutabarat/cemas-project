import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart'; // Wajib untuk mengatur MediaType

import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/article_model.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;

class ArticleRepository {
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Future<List<ArticleModel>> fetchArticles() async {
    final token = await _tokenStorageService.readToken();
    final String apiUrl = await BackendRepository.getBackendUrl();
    final headers = {'Authorization': token ?? ''};

    final responses = await Future.wait([
      http.get(
        Uri.parse('$apiUrl/api/recommendations/foods'),
        headers: headers,
      ),
      http.get(
        Uri.parse('$apiUrl/api/recommendations/activities'),
        headers: headers,
      ),
    ]);

    final responseFood = responses[0];
    final responseActivity = responses[1];

    if (responseFood.statusCode != 200 || responseActivity.statusCode != 200) {
      throw Exception(
        'Failed to load articles — '
        'food: ${responseFood.statusCode}, '
        'activity: ${responseActivity.statusCode}',
      );
    }

    List<dynamic> decodeBody(String body) =>
        body.isNotEmpty ? (jsonDecode(body) as List<dynamic>? ?? []) : [];

    final foodArticles = decodeBody(responseFood.body)
        .map((json) => ArticleModel.fromJson(json, type: ArticleType.food))
        .toList();

    final activityArticles = decodeBody(responseActivity.body)
        .map((json) => ArticleModel.fromJson(json, type: ArticleType.activity))
        .toList();

    return [...foodArticles, ...activityArticles];
  }

  Future<bool> updateArticle(ArticleModel article) async {
    final token = await _tokenStorageService.readToken();
    final String apiurl = await BackendRepository.getBackendUrl();
    final Uri uri = Uri.parse(
      '$apiurl/api/admin/articles/${article.articleType.name}/${article.id}',
    );

    final headers = {
      'Authorization': token ?? '',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = jsonEncode(article.toJson());

    final response = await http.put(uri, headers: headers, body: body);

    // Beberapa API mengembalikan 200 atau 204 untuk update sukses
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createArticle({
    required String name,
    required String description,
    required ArticleType type,
    required String anxietyLevel,
    required File imageFile,
  }) async {
    try {
      // 1. Ambil Token dan Base URL Backend
      final token = await _tokenStorageService.readToken();
      final String apiUrl = await BackendRepository.getBackendUrl();

      // Sesuaikan dengan pola endpoint kamu (misal: /api/admin/articles/food)
      final Uri uri = Uri.parse('$apiUrl/api/admin/articles/${type.name}');

      // 2. Inisialisasi MultipartRequest menggunakan method POST
      final request = http.MultipartRequest('POST', uri);

      // 3. Tambahkan Header Autentikasi
      request.headers.addAll({'Authorization': token ?? ''});

      // 4. Masukkan parameter teks ke dalam fields
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['anxiety_level'] = anxietyLevel;

      // 5. Validasi dan Masukkan File Gambar dengan Content-Type Spesifik
      if (!await imageFile.exists()) {
        if (kDebugMode) {
          print("Error: File gambar tidak ditemukan di local storage.");
        }
        return false;
      }

      // Deteksi ekstensi file untuk menentukan sub-type (jpg, jpeg, png)
      String extension = path
          .extension(imageFile.path)
          .replaceAll('.', '')
          .toLowerCase();
      if (extension == 'jpg') {
        extension = 'jpeg'; // Standar MIME menggunakan jpeg, bukan jpg
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Key yang sesuai dengan backend
          imageFile.path,
          filename: path.basename(imageFile.path),
          // PERBAIKAN UTAMA: Mengatur Content-Type file menjadi image/jpeg atau image/png
          contentType: MediaType('image', extension),
        ),
      );

      if (kDebugMode) {
        print("Mengirim data artikel baru ke: $uri");
      }
      if (kDebugMode) {
        print("Fields: ${request.fields}");
      }
      if (kDebugMode) {
        print("File Path: ${imageFile.path}");
      }

      // 6. Kirim Request
      final streamedResponse = await request.send();

      // 7. Ubah stream menjadi response biasa untuk melihat pesan dari backend
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("Response status code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Response body: ${response.body}");
      }

      // Umumnya backend mengembalikan kode 201 (Created) atau 200 (OK) saat berhasil menyimpan data baru
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Terjadi error saat membuat artikel: $e");
      }
      return false;
    }
  }
}
