import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/get_icon_level.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// Ensure this path is correct for AssessmentResult

// Assuming AssessmentResult is the same as AssessmentResult from previous models.
// If not, please adjust the import and class name accordingly.

class GuestHarsResultScreen extends StatefulWidget {
  // We need to pass the AssessmentResult to this screen
  final AssessmentResult? result;

  const GuestHarsResultScreen({super.key, this.result});

  @override
  State<GuestHarsResultScreen> createState() => _GuestHarsResultScreenState();
}

class _GuestHarsResultScreenState extends State<GuestHarsResultScreen> {
  // Custom Colors
  final Color primaryDark = const Color(0xFF1A237E);
  final Color accentColor = const Color(0xFF3949AB);
  final Color bgColor = const Color(0xFFF8FAFC);
  // Helper function to determine color based on anxiety level
  Color _getAnxietyLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'normal':
        return Colors.green.shade600;
      case 'mild anxiety':
        return Colors.yellow.shade700;
      case 'moderate anxiety':
        return Colors.orange.shade700;
      case 'severe anxiety':
        return Colors.red.shade700;
      default:
        return Colors.red.shade800;
    }
  }

  // Helper function for a descriptive message (can be expanded)
  String _getDescriptiveMessage(String level) {
    switch (level.toLowerCase()) {
      case 'normal':
        return 'It looks like you\'re experiencing very low levels of anxiety. Keep up your self-care routines!';
      case 'mild anxiety':
        return 'You\'re showing mild signs of anxiety. Small adjustments to daily habits can often help. Consider exploring relaxation techniques.';
      case 'moderate anxiety':
        return 'Your results suggest moderate anxiety. It might be helpful to talk to a professional or explore stress management strategies.';
      case 'severe anxiety':
        return 'Your score indicates severe anxiety. We strongly recommend seeking professional support from a doctor or mental health specialist.';
      default:
        return 'Thank you for completing the survey. We recommend reviewing your results.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color levelColor = _getAnxietyLevelColor(widget.result!.anxietyLevel);
    final String descriptiveMessage = _getDescriptiveMessage(
      widget.result!.anxietyLevel,
    );
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          bgColor, // Ensure the whole screen has a background color
      body: SafeArea(
        child: responsiveLayout(
          content: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              // FIX: This forces the container to be at least the height of the browser
              constraints: BoxConstraints(minHeight: screenHeight),
              padding: const EdgeInsets.only(bottom: 40), // Space at the bottom
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 60, bottom: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryDark, accentColor],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "HARS Survey Result",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 2. Main Content Wrapper
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Icon(
                            getIconLevel(widget.result!.anxietyLevel),
                            size: 100,
                            color: levelColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: levelColor.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  '${l10n.anxietylevelis}:',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.result!.anxietyLevel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: levelColor,
                                    fontSize: 32,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildResultRow(
                          context,
                          'Total Score',
                          '${widget.result?.totalScore} / 56',
                          Icons.analytics,
                          primaryDark,
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l10n.whatthismeans}:',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  descriptiveMessage,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(
                            context,
                            'Return to Home',
                            Icons.home,
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed('/dashboard'),
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return FilledButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isPrimary
            ? Theme.of(context).primaryColor
            : Colors.grey.shade200,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16),
        elevation: isPrimary ? 5 : 2,
      ),
    );
  }
}
