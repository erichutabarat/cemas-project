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

  Future<bool> analyzeHeartbeat(int inspectionID) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final Uri analyzeUrl = Uri.parse('$apiurl/api/heartbeat/analyze');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    // 1. Tambahkan Content-Type di headers
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // 2. Bungkus data ke dalam format JSON String
    final body = jsonEncode({'inspection_id': inspectionID});

    // 3. Kirim request dengan menyertakan body
    final response = await http.post(analyzeUrl, headers: headers, body: body);

    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
