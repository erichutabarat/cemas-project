import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/data/models/heartbeat_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;

class HeartbeatRepository {
  final tokenService = TokenStorageService();

  Future<UploadResponse> uploadHeartbeatData(String filepath) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final Uri uploadUrl = Uri.parse('$apiurl/api/heartbeat/upload');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};
    final request = http.MultipartRequest('POST', uploadUrl);
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      return UploadResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to upload heartbeat data');
    }
  }
}
