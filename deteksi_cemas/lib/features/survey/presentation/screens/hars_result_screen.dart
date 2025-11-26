import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Ensure this path is correct for AssessmentResult

// Assuming AssessmentResult is the same as AssessmentResult from previous models.
// If not, please adjust the import and class name accordingly.

class HarsResultScreen extends StatefulWidget {
  // We need to pass the AssessmentResult to this screen
  final AssessmentResult? result;

  const HarsResultScreen({super.key, this.result});

  @override
  State<HarsResultScreen> createState() => _HarsResultScreenState();
}

class _HarsResultScreenState extends State<HarsResultScreen> {
  // Helper function to determine color based on anxiety level
  Color _getAnxietyLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'no anxiety':
        return Colors.green.shade600;
      case 'mild anxiety':
        return Colors.yellow.shade700;
      case 'moderate anxiety':
        return Colors.orange.shade700;
      case 'severe anxiety':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  // Helper function for a descriptive message (can be expanded)
  String _getDescriptiveMessage(String level) {
    switch (level.toLowerCase()) {
      case 'no anxiety':
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
    final Color levelColor = _getAnxietyLevelColor(widget.result!.anxietyLevel);
    final String descriptiveMessage = _getDescriptiveMessage(
      widget.result!.anxietyLevel,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HARS Survey Results'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          // Custom back button to go to main app screen, not back to survey questions
          icon: const Icon(
            Icons.close,
          ), // Or Icons.arrow_back, depending on desired navigation
          onPressed: () => Navigator.of(context).popUntil(
            (route) => route.isFirst,
          ), // Pops all routes until the first one
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Confetti/Celebration or prominent icon
              Center(
                child: Icon(
                  widget.result?.anxietyLevel.toLowerCase() == 'no anxiety'
                      ? Icons.check_circle_outline
                      : Icons.sentiment_neutral, // Or Icons.warning if severe
                  size: 100,
                  color: levelColor,
                ),
              ),
              const SizedBox(height: 20),

              // Title Card for Anxiety Level
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: levelColor.withOpacity(0.1), // Soft background color
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Your Anxiety Level Is:',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.grey.shade700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.result!.anxietyLevel,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: levelColor,
                              fontSize: 40,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Total Score Display
              _buildResultRow(
                context,
                'Total Score',
                '${widget.result?.totalScore} / 56', // Assuming 56 is the max HARS score
                Icons.score,
                Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),

              // Descriptive Message Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What This Means:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        descriptiveMessage,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons (Next Steps)
              Text(
                'Next Steps:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildActionButton(
                context,
                'View Anxiety Resources',
                Icons.book,
                () {
                  // TODO: Navigate to a screen with coping strategies, articles, etc.
                  if (kDebugMode) {
                    print('Navigate to resources');
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Find Professional Help',
                Icons.medical_services,
                () {
                  // TODO: Navigate to a screen to find therapists, doctors, etc.
                  if (kDebugMode) {
                    print('Navigate to professional help');
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                context,
                'Go to Home',
                Icons.home,
                () {
                  // Navigate back to the main dashboard/home screen
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                isPrimary: true, // Make this button more prominent
              ),
            ],
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
