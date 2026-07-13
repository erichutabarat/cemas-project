import 'package:deteksi_cemas/features/dashboard/data/models/journal_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JournalingRepository {
  // Add your repository methods and properties here
  final tokenService = TokenStorageService();
  final String journalEndpoint = '/api/user/journal';

  // Get user history

  Future<void> deleteJournalByID(int id) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl$journalEndpoint/$id');
    final token = await tokenService.readToken();
    if (token == null) {
      throw Exception('Authorization token not found.');
    }
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // if (kDebugMode) {
      //   print("Successfully deleted journal entry with ID: $id");
      // }
      return;
    } else {
      throw Exception('Failed to delete journal entry: ${response.statusCode}');
    }
  }

  Future<List<JournalEntry>> fetchJournalHistory() async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl$journalEndpoint');
    final token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => JournalEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load journal history: ${response.statusCode}');
    }
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final String apiurl = await BackendRepository.getBackendUrl();
    final url = Uri.parse('$apiurl$journalEndpoint');
    final token = await tokenService.readToken();

    if (token == null) {
      throw Exception('Authorization token not found.');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(entry.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save journal entry: ${response.statusCode}');
    }
  }
}
