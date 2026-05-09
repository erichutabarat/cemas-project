// lib/features/dashboard_admin/presentation/widgets/hars_stats_chart.dart

import 'package:deteksi_cemas/features/dashboard_admin/data/models/hars_reponse_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HarsStatsChart extends StatelessWidget {
  final List<HarsResponse> responses;

  const HarsStatsChart({super.key, required this.responses});

  // ─── Level config ─────────────────────────────────────────────────────────

  static const _levels = [
    'Normal',
    'Mild Anxiety',
    'Moderate Anxiety',
    'Severe Anxiety',
  ];

  static const _levelColors = [
    Color(0xFF3B6D11),
    Color(0xFFBA7517),
    Color(0xFFD85A30),
    Color(0xFFA32D2D),
  ];

  static const _maxScore = 56;

  Color _colorForLevel(String level) {
    final i = _levels.indexOf(level);
    return i >= 0 ? _levelColors[i] : Colors.grey;
  }

  // ─── Computed data ────────────────────────────────────────────────────────

  Map<String, int> get _countByLevel {
    final map = {for (final l in _levels) l: 0};
    for (final r in responses) {
      if (map.containsKey(r.level)) map[r.level] = map[r.level]! + 1;
    }
    return map;
  }

  double get _avgScore {
    if (responses.isEmpty) return 0;
    return responses.map((r) => r.score).reduce((a, b) => a + b) /
        responses.length;
  }

  int get _maxResponseScore => responses.isEmpty
      ? 0
      : responses.map((r) => r.score).reduce((a, b) => a > b ? a : b);

  String get _dominantLevel {
    final counts = _countByLevel;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  // In HarsStatsChart — replace SingleChildScrollView with:
  @override
  Widget build(BuildContext context) {
    if (responses.isEmpty) {
      return const Center(
        child: Text('Tidak ada data', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // ← don't expand, take only needed space
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildSummaryCards(),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel('Distribusi tingkat kecemasan'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildLevelLegend(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildLevelBarChart(),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel('Distribusi skor per responden'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildScoreLineChart(),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel('Gender per tingkat kecemasan'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildGenderLegend(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildGenderStackedChart(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Summary metric cards ───────────────────────────────────────────────────

  Widget _buildSummaryCards() {
    final items = [
      ('Total respons', '${responses.length}', null),
      ('Rata-rata skor', _avgScore.toStringAsFixed(1), 'dari $_maxScore'),
      ('Terbanyak', _dominantLevel, null),
      ('Skor tertinggi', '$_maxResponseScore', null),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.$1,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                item.$2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.$3 != null)
                Text(
                  item.$3!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Level distribution bar chart ───────────────────────────────────────────

  Widget _buildLevelBarChart() {
    final counts = _countByLevel;
    final maxY = (counts.values.reduce((a, b) => a > b ? a : b) + 2).toDouble();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: List.generate(_levels.length, (i) {
            final level = _levels[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: counts[level]!.toDouble(),
                  color: _levelColors[i],
                  width: 28,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 2,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, _) {
                  const short = ['Normal', 'Mild', 'Moderate', 'Severe'];
                  final i = v.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      i < short.length ? short[i] : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                '${_levels[group.x]}\n${rod.toY.toInt()} responden',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Score line chart ───────────────────────────────────────────────────────

  Widget _buildScoreLineChart() {
    // Sort by date (already sorted descending from API, reverse for timeline)
    final sorted = [...responses].reversed.toList();

    final spots = List.generate(
      sorted.length,
      (i) => FlSpot(i.toDouble(), sorted[i].score.toDouble()),
    );

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: _maxScore.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF1E3A8A),
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, i) {
                  final level = sorted[i].level;
                  return FlDotCirclePainter(
                    radius: 4,
                    color: _colorForLevel(level),
                    strokeWidth: 1.5,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF1E3A8A).withOpacity(0.06),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 14,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final resp = sorted[s.spotIndex];
                return LineTooltipItem(
                  '${resp.guest.name.trim()}\nSkor: ${resp.score} • ${resp.level}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ── Gender stacked bar chart ───────────────────────────────────────────────

  Widget _buildGenderStackedChart() {
    // Count female/male per level
    final female = {for (final l in _levels) l: 0};
    final male = {for (final l in _levels) l: 0};
    for (final r in responses) {
      if (!_levels.contains(r.level)) continue;
      if (r.guest.gender.toLowerCase() == 'female') {
        female[r.level] = female[r.level]! + 1;
      } else {
        male[r.level] = male[r.level]! + 1;
      }
    }

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(_levels.length, (i) {
            final level = _levels[i];
            final f = female[level]!.toDouble();
            final m = male[level]!.toDouble();
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: f + m,
                  width: 28,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  rodStackItems: [
                    BarChartRodStackItem(0, f, const Color(0xFF185FA5)),
                    BarChartRodStackItem(f, f + m, const Color(0xFF1D9E75)),
                  ],
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 2,
                getTitlesWidget: (v, _) => Text(
                  '${v.toInt()}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, _) {
                  const short = ['Normal', 'Mild', 'Moderate', 'Severe'];
                  final i = v.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      i < short.length ? short[i] : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    ),
  );

  Widget _buildLevelLegend() => Wrap(
    spacing: 14,
    runSpacing: 6,
    children: List.generate(
      _levels.length,
      (i) => _legendDot(_levels[i], _levelColors[i]),
    ),
  );

  Widget _buildGenderLegend() => Wrap(
    spacing: 14,
    children: [
      _legendDot('Female', const Color(0xFF185FA5)),
      _legendDot('Male', const Color(0xFF1D9E75)),
    ],
  );

  Widget _legendDot(String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}
