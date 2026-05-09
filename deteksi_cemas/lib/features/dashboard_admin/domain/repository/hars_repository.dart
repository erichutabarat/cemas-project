import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/hars_models.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/hars_reponse_models.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HarsRepository {
  final tokenService = TokenStorageService();

  Future<List<HarsQuestions>> fetchHarsQuestions() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/admin/hars/questions');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': token};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Fetched HARS Questions: $jsonResponse');
      } // Debug print
      final List<dynamic> data = jsonResponse['hars_questions'] ?? [];
      return data.map((json) => HarsQuestions.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load HARS questions: ${response.statusCode}');
    }
  }

  Future<List<HarsResponse>> fetchHarsResponses() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/assessment/guest-results');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': token};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('Fetched HARS Responses: $jsonResponse');
      } // Debug print
      final List<dynamic> data = jsonResponse['data'] ?? [];
      return data.map((json) => HarsResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load HARS responses: ${response.statusCode}');
    }
  }
}
