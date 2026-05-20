import 'package:deteksi_cemas/features/dashboard/data/models/userprofile_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  // Add your repository methods and properties here
  final tokenService = TokenStorageService();
  final String userProfileEndpoint = '/api/user/profile';

  // Get User Profile
  Future<UserProfile> fetchUserProfile() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl$userProfileEndpoint');
    final token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return UserProfile.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  // Get user history
  Future<List<dynamic>> fetchUsersSurveyHistory() async {
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
      // if (kDebugMode) {
      //   print("Test call user history: $jsonResponse");
      // }
      return jsonResponse['hars_results'] ?? [];
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  Future<void> deleteSurveyResultByID(int id) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/assessment/result/$id');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // if (kDebugMode) {
      //   print("Successfully deleted survey result with ID: $id");
      // }
      return;
    } else {
      throw Exception('Failed to delete survey result: ${response.statusCode}');
    }
  }

  Future<bool> updateProfile(UserProfile profile) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl/api/user/update');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    print("request body: ${profile.toJson()}");

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(profile.toJson());

    final response = await http.put(url, headers: headers, body: body);

    print("response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }
}
