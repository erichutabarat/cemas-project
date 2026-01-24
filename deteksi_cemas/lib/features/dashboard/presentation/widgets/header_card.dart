// ignore_for_file: sized_box_for_whitespace, deprecated_member_use

import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderCard extends StatelessWidget {
  final String name;

  const HeaderCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const double headerHeight = 200.0;
    const double cardHeight = 100.0;

    const double totalStackHeight = headerHeight;
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: totalStackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: headerHeight - (cardHeight / 2),
            decoration: BoxDecoration(
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
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Positioned(
            top: topPadding + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // User Profile Icon
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
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Notification Icon
                const Icon(
                  Icons.notifications_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          // 3. Quick Information Card (Widget Two - Overlapping)
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: cardHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickInfoItem(
                    icon: FontAwesomeIcons.solidHeart,
                    color: Colors.red.shade600,
                    label: "HR",
                    value: "80 bpm",
                  ),
                  _buildQuickInfoItem(
                    icon: FontAwesomeIcons.heartPulse,
                    color: Colors.red.shade600,
                    label: "BPM",
                    value: "120/80",
                  ),
                  _buildQuickInfoItem(
                    icon: FontAwesomeIcons.stethoscope,
                    color: Colors.red.shade600,
                    label: "Score",
                    value: "95",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function remains the same
  Widget _buildQuickInfoItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
