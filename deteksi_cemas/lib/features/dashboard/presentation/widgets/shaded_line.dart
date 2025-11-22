import 'package:flutter/material.dart';

class ShadedLineWidget extends StatelessWidget {
  const ShadedLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List rateZone = [
      {'name': 'Healthy', 'bpm': 60, 'color': Colors.orange},
      {'name': 'Low', 'bpm': 100, 'color': Colors.red.shade400},
      {'name': 'Moderate', 'bpm': 130, 'color': Colors.red.shade600},
      {'name': 'High', 'bpm': 160, 'color': Colors.red.shade800},
    ];

    const double lineHeight = 12.0;
    const double lineWidth = 80.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: rateZone.map((zone) {
        return Column(
          children: [
            Container(
              height: lineHeight,
              width: lineWidth,
              color: zone['color'],
              margin: const EdgeInsets.symmetric(
                vertical: 0.5,
              ), // Small gap between lines
            ),
            SizedBox(height: 8),
            Text(
              " ${zone['bpm']} ",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              " ${zone['name']} ",
              style: TextStyle(
                color: zone['color'],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
