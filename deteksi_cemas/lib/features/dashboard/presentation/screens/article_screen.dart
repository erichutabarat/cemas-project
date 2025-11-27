import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_survey_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  final ScrollController? controller;
  const ArticleScreen({super.key, required this.controller});

  // Example data (replace with actual backend data)
  final String lastSurveyDate = 'Nov 25, 2025 at 10:30 AM';
  final int lastScore = 18;
  final String interpretation = 'Mild Anxiety';
  final Color scoreColor = Colors.orange;

  final List<Map<String, dynamic>> history = const [
    {'date': 'Nov 18, 2025', 'score': 12},
    {'date': 'Nov 11, 2025', 'score': 25},
    {'date': 'Nov 04, 2025', 'score': 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "HARS Survey",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // --- 2. Survey Information ---
            _buildInfoCard(context),
            const SizedBox(height: 24),

            // --- 3. Action Block (Start Survey) ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  if (kDebugMode) {
                    print('Start Survey tapped!');
                  }
                  startSurvey(context);
                },
                icon: const Icon(Icons.psychology_alt),
                label: const Text(
                  'Start New Survey',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- 4. Last Survey Summary ---
            if (lastScore > 0) ...[
              Text(
                'Your Last Result',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildLastResultCard(context),
              const SizedBox(height: 32),
            ],

            // --- 5. Survey History ---
            Text(
              'Survey History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // List of previous results
            ...history.map((result) {
              return ListTile(
                leading: const Icon(Icons.calendar_month, color: Colors.grey),
                title: Text(result['date']!),
                subtitle: Text('Score: ${result['score']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to the detailed view for this history item
                  if (kDebugMode) {
                    print('View history for ${result['date']}');
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is HARS?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'The Hamilton Anxiety Rating Scale (HARS) is a 14-item survey used to assess the severity of anxiety symptoms. Each item is rated on a 0-4 scale. The total score helps determine your level of anxiety (e.g., normal, mild, moderate, severe).',
            ),
            const SizedBox(height: 12),
            const Text(
              'Disclaimer: This tool is for informational tracking only and is not a substitute for professional medical diagnosis or treatment.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastResultCard(BuildContext context) {
    return Card(
      color: scoreColor.withValues(alpha: 0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scoreColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interpretation,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed: $lastSurveyDate',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: scoreColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$lastScore',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSurvey(BuildContext context) {
    // 2. Instantiate the repository manually
    final repository = HarsQuestionsRepository();

    // 3. Navigate and pass the required argument
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HarsSurveyScreen(
          surveyRepository: repository, // <-- FIX: Passing the dependency
        ),
      ),
    );
  }
}
