// survey_repository.dart
import 'dart:convert';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';

class HarsQuestionsRepository {
  Future<List<AssessmentQuestion>> fetchHarsQuestions() async {
    final String apiUrl = await BackendRepository.getBackendUrl();
    final tokenService = TokenStorageService();
    String? token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};

    final url = Uri.parse('$apiUrl/api/assessment/questions');

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

  Future<bool> fetchHarsSubmit(AssessmentResult result) async {
    final String apiUrl = await BackendRepository.getBackendUrl();
    final tokenService = TokenStorageService();
    String? token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final url = Uri.parse('$apiUrl/api/assessment/submit');

    // 1. Define required headers: Content-Type and Authorization
    final headers = {
      'Content-Type':
          'application/json', // <-- CRITICAL: Tells the backend the body is JSON
      'Authorization': 'Bearer $token',
    };

    // 2. Prepare the request body: Convert the 'result' object to a JSON string
    // You MUST have a toJson() or toMap() method on your AssessmentResult model
    final body = jsonEncode(result.toMap()); // <-- CRITICAL: Encode the data

    try {
      // 3. Make the POST request, including headers and the encoded body
      final response = await http.post(
        url,
        headers: headers,
        body: body, // <-- POST request body is now included
      );

      if (response.statusCode == 200) {
        // You can optionally check the message here if needed
        // final jsonResponse = jsonDecode(response.body);
        // final String message = jsonResponse['message'];

        return true; // Submission successful
      } else {
        // Log or print the response body for better debugging of backend errors
        if (kDebugMode) {
          print(
            'Submission failed with status ${response.statusCode}. Body: ${response.body}',
          );
        }
        throw Exception('Failed to submit assessment: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      if (kDebugMode) {
        print('Network error during submission: $e');
      }
      throw Exception('Failed to submit assessment due to network error.');
    }
  }
}
