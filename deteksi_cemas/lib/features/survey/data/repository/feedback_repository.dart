import 'dart:convert';

import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:deteksi_cemas/features/survey/data/models/feedback_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/guest_models.dart';
import 'package:http/http.dart' as http;

class FeedbackRepository {
  Future<List<FeedbackQuestion>> fetchFeedbackQuestions() async {
    final String apiUrl = await BackendRepository.getBackendUrl();

    final url = Uri.parse('$apiUrl/api/feedback/questions');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return feedbackQuestionsFromJson(response.body);
    } else {
      throw Exception('Failed to fetch feedback questions.');
    }
  }

  // In your FeedbackRepository class
  // feedback_repository.dart
  Future<void> submitFeedback({
    required Guest guest,
    required List<Map<String, dynamic>> feedbacks,
  }) async {
    final String apiUrl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiUrl/api/feedback/submit');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "guest": {
          "name": guest.name,
          "email": guest.email,
          "gender": guest.gender,
          "age": guest.age,
        },
        "feedbacks":
            feedbacks, // This will now contain feedback_question_id and response
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit feedback: ${response.body}');
    }
  }
}
