import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistorySummaryCard extends StatelessWidget {
  final Future<Map<String, dynamic>> historyFuture;

  const HistorySummaryCard({super.key, required this.historyFuture});

  /// Parses the raw history response into summary stats.
  static Map<String, dynamic> parseHistory(Map<String, dynamic> json) {
    final harsResults = List<Map<String, dynamic>>.from(
      json['hars_results'] ?? [],
    );
    final inspections = List<Map<String, dynamic>>.from(
      json['inspections'] ?? [],
    );

    // Latest HARS: sorted by CreatedAt descending, take first
    final sortedHars = List<Map<String, dynamic>>.from(harsResults)
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a['CreatedAt'] ?? '') ?? DateTime(0);
        final bDate = DateTime.tryParse(b['CreatedAt'] ?? '') ?? DateTime(0);
        return bDate.compareTo(aDate);
      });

    final latestHars = sortedHars.isNotEmpty ? sortedHars.first : null;
    final latestScore = latestHars?['score'] as int?;
    final latestLevel = latestHars?['level'] as String? ?? '-';

    return {
      'totalHars': harsResults.length,
      'totalInspections': inspections.length,
      'latestScore': latestScore,
      'latestLevel': latestLevel,
    };
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'normal':
        return Colors.green.shade600;
      case 'mild anxiety':
        return Colors.yellow.shade700;
      case 'moderate anxiety':
        return Colors.orange.shade600;
      case 'severe anxiety':
      case 'very serious anxiety':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCard(context, isLoading: true);
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildCard(context, isError: true);
        }
        final stats = parseHistory(snapshot.data!);
        return _buildCard(context, stats: stats);
      },
    );
  }

  Widget _buildCard(
    BuildContext context, {
    Map<String, dynamic>? stats,
    bool isLoading = false,
    bool isError = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          : isError
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade400, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Failed to load history',
                  style: TextStyle(color: Colors.red.shade400, fontSize: 14),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: FontAwesomeIcons.clipboardList,
                  iconColor: ColorList.aquaCyan,
                  label: 'HARS Tests',
                  value: '${stats!['totalHars']}',
                  subLabel: 'total filled',
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: FontAwesomeIcons.heartPulse,
                  iconColor: Colors.indigo.shade400,
                  label: 'Inspections',
                  value: '${stats['totalInspections']}',
                  subLabel: 'recorded',
                ),
                _buildDivider(),
                _buildLatestScoreItem(
                  score: stats['latestScore'],
                  level: stats['latestLevel'] as String,
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subLabel,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subLabel,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestScoreItem({required int? score, required String level}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.chartLine,
                color: Colors.teal.shade400,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Latest HARS',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            score != null ? '$score' : '-',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _levelColor(level).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _levelColor(level),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 50, width: 1, color: Colors.grey.shade200);
  }
}
