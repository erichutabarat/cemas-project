import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/statistics_model.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StatisticsRepository {
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Future<StatisticsModel> fetchStatistics() async {
    try {
      final token = await _tokenStorageService.readToken();
      final String apiurl = await BackendRepository.getBackendUrl();
      final url = Uri.parse('$apiurl/api/admin/users/statistics');

      final response = await http.get(
        url,
        headers: {'Authorization': token ?? ''},
      );

      if (kDebugMode) {
        print("response status: ${response.statusCode}");
        print("response body: ${response.body}");
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch statistics: ${response.statusCode}');
      }
      final responseData = jsonDecode(response.body);
      return StatisticsModel.fromJson(responseData);
    } catch (e) {
      throw Exception('Failed to fetch statistics: $e');
    }
  }
}
