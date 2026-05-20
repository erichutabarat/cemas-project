import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:deteksi_cemas/features/survey/domain/repository/article_recommendation_repository.dart';
import 'package:flutter/material.dart';

class ArticleRecommendation extends StatefulWidget {
  final String level;
  const ArticleRecommendation({super.key, required this.level});

  @override
  State<ArticleRecommendation> createState() => _ArticleRecommendationState();
}

class _ArticleRecommendationState extends State<ArticleRecommendation> {
  late Future<Map<String, dynamic>> _recommendationsFuture;
  late String _backendUrl;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = ArticleRecommendationRepository()
        .fetchRecommendations();
    _loadBackendUrl();
  }

  Future<void> _loadBackendUrl() async {
    final url = await BackendRepository.getBackendUrl();
    if (mounted) setState(() => _backendUrl = url);
  }

  String _normalizeLevel(String level) {
    switch (level.toLowerCase().trim()) {
      case 'normal':
      case 'low anxiety':
        return 'Low Anxiety';
      case 'mild anxiety':
        return 'Mild Anxiety';
      case 'moderate anxiety':
        return 'Moderate Anxiety';
      case 'severe anxiety':
        return 'Severe Anxiety';
      case 'very severe anxiety':
      case 'very serious anxiety':
        return 'Very Severe Anxiety';
      default:
        return 'Low Anxiety'; // safest fallback
    }
  }

  List<dynamic> _filter(List<dynamic> items) {
    final normalizedWidgetLevel = _normalizeLevel(widget.level);
    return items
        .where(
          (item) =>
              _normalizeLevel(item['anxiety_level'] ?? '') ==
              normalizedWidgetLevel,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat rekomendasi: ${snapshot.error}'),
          );
        }

        final data = snapshot.data!;
        final activities = _filter(data['activities'] as List<dynamic>? ?? []);
        final foods = _filter(data['foods'] as List<dynamic>? ?? []);

        if (activities.isEmpty && foods.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foods.isNotEmpty) ...[
              _buildSectionHeader('🍎  Rekomendasi Makanan', Colors.orange),
              const SizedBox(height: 12),
              _buildHorizontalList(foods),
              const SizedBox(height: 24),
            ],
            if (activities.isNotEmpty) ...[
              _buildSectionHeader('🏃  Rekomendasi Aktivitas', Colors.blue),
              const SizedBox(height: 12),
              _buildHorizontalList(activities),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildHorizontalList(List<dynamic> items) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildArticleCard(items[index]),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> item) {
    final imageUrl = '$_backendUrl${item['image_url']}';

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────────────────────
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[100],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 36,
                ),
              ),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
            ),
          ),

          // ── Text ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item['description'] ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
