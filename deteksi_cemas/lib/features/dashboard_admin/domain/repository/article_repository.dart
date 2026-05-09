import 'dart:convert';

import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/article_model.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:http/http.dart' as http;

class ArticleRepository {
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Future<List<ArticleModel>> fetchArticles() async {
    final token = await _tokenStorageService.readToken();
    final String apiurl = await BackendRepository.getBackendUrl();
    final articleFood = Uri.parse('$apiurl/api/recommendations/foods');
    final articleActivity = Uri.parse('$apiurl/api/recommendations/activities');
    final headers = {'Authorization': token ?? ''};
    final responseFood = await http.get(articleFood, headers: headers);
    final responseActivity = await http.get(articleActivity, headers: headers);

    if (responseFood.statusCode == 200 && responseActivity.statusCode == 200) {
      final List<dynamic> foodData = (responseFood.body.isNotEmpty)
          ? (jsonDecode(responseFood.body) ?? [])
          : [];
      final List<dynamic> activityData = (responseActivity.body.isNotEmpty)
          ? (jsonDecode(responseActivity.body) ?? [])
          : [];
      final List<ArticleModel> articles = [
        ...foodData.map((json) => ArticleModel.fromJson(json)),
        ...activityData.map((json) => ArticleModel.fromJson(json)),
      ];
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
