import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  // Add your repository methods and properties here
  final String _baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';
  final tokenService = TokenStorageService();

  // Get user history
  Future<List<dynamic>> fetchUsersSurveyHistory() async {
    final url = Uri.parse('$_baseUrl/api/user/history');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // if (kDebugMode) {
      //   print("Test call user history: $jsonResponse");
      // }
      return jsonResponse['hars_results'] ?? [];
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
