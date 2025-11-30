import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http; // Make sure you import http

class RecommendationRepository {
  final String _baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  // Change return type to a more specific Map<String, dynamic>
  Future<Map<String, dynamic>> fetchRecommendations() async {
    final urlActivity = Uri.parse('$_baseUrl/api/recommendations/activities');
    final urlFoods = Uri.parse('$_baseUrl/api/recommendations/foods');

    // Fetch both in parallel for performance
    final results = await Future.wait([
      http.get(urlActivity),
      http.get(urlFoods),
    ]);

    final responseActivity = results[0];
    final responseFoods = results[1];

    if (responseActivity.statusCode == 200 && responseFoods.statusCode == 200) {
      try {
        // Decode the JSON string into Dart objects (likely List<Map<String, dynamic>>)
        final activities = jsonDecode(responseActivity.body);
        final foods = jsonDecode(responseFoods.body);

        // Return a Map with decoded data
        return {'activities': activities, 'foods': foods};
      } catch (e) {
        throw Exception('Failed to parse recommendations data: $e');
      }
    } else {
      // Provide more detail in the exception
      throw Exception(
        'Failed to load recommendations. Activity Status: ${responseActivity.statusCode}, Foods Status: ${responseFoods.statusCode}',
      );
    }
  }
}
