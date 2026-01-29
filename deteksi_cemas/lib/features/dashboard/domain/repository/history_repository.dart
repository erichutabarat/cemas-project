import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/data/models/medical_record_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;

class HistoryRepository {
  final tokenService = TokenStorageService();

  // Get user history
  Future<List<MedicalRecordModel>> fetchUsersInspectionHistory() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/user/history');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['inspections'] ?? [];

      // Convert List<Map> to List<MedicalRecordModel>
      // Use .toList() and ensure the map returns the correct type
      return data.map((json) => MedicalRecordModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
