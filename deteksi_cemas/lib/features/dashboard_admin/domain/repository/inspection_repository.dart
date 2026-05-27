import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/inspection_model.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;

class InspectionsRepository {
  final tokenService = TokenStorageService();

  Future<List<Inspection>> getInspections() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/admin/inspections');
    final token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final headers = {'Authorization': token};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // 1. Decode the string body into a Dart Map first
      final Map<String, dynamic> decodedBody =
          json.decode(response.body) as Map<String, dynamic>;

      // 2. Extract the list from the 'inspections' key
      final List<dynamic> data = decodedBody['inspections'] as List<dynamic>;

      // 3. Map the data elements into your Inspection objects
      return data
          .map((e) => Inspection.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load inspections. Status code: ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> updateInspectionFilename(
    int inspectionId,
    String newFilename,
  ) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/admin/inspections/$inspectionId');
    final token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final headers = {'Authorization': token};
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode({'file_name': newFilename}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to update inspection filename. Status code: ${response.statusCode}',
      );
    }
  }
}
