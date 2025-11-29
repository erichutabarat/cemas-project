// survey_repository.dart
import 'dart:convert';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';

class HarsQuestionsRepository {
  final String _baseUrl = "http://192.168.1.46:8080";

  Future<List<AssessmentQuestion>> fetchHarsQuestions() async {
    final tokenService = TokenStorageService();
    String? token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};

    final url = Uri.parse('$_baseUrl/api/assessment/questions');

    // IMPORTANT: If this route is protected, you must include the JWT token in the headers!
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Assuming the Go backend returns {"status": "success", "data": [...]}
      final List<dynamic> questionListJson = jsonResponse['questions'];

      // Map the list of JSON objects to AssessmentQuestion models
      return questionListJson
          .map(
            (json) => AssessmentQuestion.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to load HARS questions: ${response.statusCode}');
    }
  }
}
