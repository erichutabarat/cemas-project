// ignore_for_file: sized_box_for_whitespace, deprecated_member_use

import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderCard extends StatelessWidget {
  final String name;
  final Future<Map<String, dynamic>> historyFuture;

  const HeaderCard({
    super.key,
    required this.name,
    required this.historyFuture,
  });

  // ── Colour helper ──────────────────────────────────────────────────────────
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
        return Colors.grey.shade500;
    }
  }

  // ── Data parser ────────────────────────────────────────────────────────────
  Map<String, dynamic> _parseHistory(Map<String, dynamic> json) {
    final harsResults = List<Map<String, dynamic>>.from(
      json['hars_results'] ?? [],
    );
    final inspections = List<Map<String, dynamic>>.from(
      json['inspections'] ?? [],
    );

    final sortedHars = List<Map<String, dynamic>>.from(harsResults)
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a['CreatedAt'] ?? '') ?? DateTime(0);
        final bDate = DateTime.tryParse(b['CreatedAt'] ?? '') ?? DateTime(0);
        return bDate.compareTo(aDate);
      });

    final latestHars = sortedHars.isNotEmpty ? sortedHars.first : null;

    return {
      'totalHars': harsResults.length,
      'totalInspections': inspections.length,
      'latestScore': latestHars?['score'] as int?,
      'latestLevel': latestHars?['level'] as String? ?? '-',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const double headerHeight = 200.0;
    const double cardHeight = 100.0;
    final double topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // ── Cyan header background ──────────────────────────────────────
          Container(
            height: headerHeight - (cardHeight / 2),
            decoration: BoxDecoration(
              color: ColorList.aquaCyan,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),

          // ── Greeting row ────────────────────────────────────────────────
          Positioned(
            top: topPadding + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcome_back,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.notifications_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // ── History summary card (overlapping) ──────────────────────────
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: cardHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: historyFuture,
                builder: (context, snapshot) {
                  // ── Loading ──
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    );
                  }

                  // ── Error ──
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade400,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Failed to load history',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  }

                  // ── Data ──
                  final stats = _parseHistory(snapshot.data!);
                  final latestLevel = stats['latestLevel'] as String;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoItem(
                        icon: FontAwesomeIcons.clipboardList,
                        color: ColorList.aquaCyan,
                        label: 'HARS Tests',
                        value: '${stats['totalHars']}',
                      ),
                      _buildDivider(),
                      _buildInfoItem(
                        icon: FontAwesomeIcons.heartPulse,
                        color: Colors.indigo.shade400,
                        label: 'Inspections',
                        value: '${stats['totalInspections']}',
                      ),
                      _buildDivider(),
                      _buildLatestScore(
                        score: stats['latestScore'],
                        level: latestLevel,
                        levelColor: _levelColor(latestLevel),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _buildInfoItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestScore({
    required int? score,
    required String level,
    required Color levelColor,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.chartLine, color: levelColor, size: 16),
              const SizedBox(width: 6),
              Text(
                'Latest Score',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            score != null ? '$score' : '-',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: levelColor,
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
    return Container(width: 1, height: 45, color: Colors.grey.shade200);
  }
}
