import 'package:deteksi_cemas/features/dashboard/domain/repository/user_repository.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_survey_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleScreen extends StatefulWidget {
  final ScrollController? controller;
  const ArticleScreen({super.key, required this.controller});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final UserRepository userRepository = UserRepository();
  late Future<List<dynamic>> userHistoryFuture;

  @override
  void initState() {
    super.initState();
    // Fetch user history from the repository
    userHistoryFuture = userRepository.fetchUsersSurveyHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.controller,
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
            SizedBox(height: 12),
            // --- 2. Survey Information ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildInfoCard(context),
            ),
            const SizedBox(height: 12),

            // --- 3. Action Block (Start Survey) ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
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
            ),
            const SizedBox(height: 12),

            // --- 4. Survey History ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Survey History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 0),

            // List of previous results
            FutureBuilder<List<dynamic>>(
              // 👈 1. Declare the Future type
              future: userHistoryFuture, // 👈 2. Pass your Future variable
              builder: (context, snapshot) {
                // --- State 1: ConnectionState.waiting (or active) ---
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // --- State 2: Error ---
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // --- State 3: Data Ready (snapshot.hasData == true) ---
                // The data is available in snapshot.data
                final List<dynamic> historyData = snapshot.data ?? [];

                if (historyData.isEmpty) {
                  return const Center(child: Text('No history records found.'));
                }

                // Build the list using ListView.builder
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: historyData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Access the dynamic data (which is a Map<String, dynamic> for each item)
                      final item = historyData[index];

                      final int id = item['ID'];
                      final int score = item['score'];
                      final String level = item['level'];
                      final Color levelColor = _getLevelColor(
                        level,
                      ); // Get the color
                      final DateTime? createdAt = item['CreatedAt'] != null
                          ? DateTime.tryParse(item['CreatedAt'])
                          : null;

                      final String dateString = createdAt != null
                          ? DateFormat('MMM dd, yyyy').format(
                              createdAt.toLocal(),
                            ) // Use intl package for better formatting
                          : 'N/A';

                      // Assessment Result
                      final AssessmentResult result = AssessmentResult(
                        id: id,
                        totalScore: score,
                        anxietyLevel: level,
                        createdAt: createdAt,
                      );

                      // -------------------------------------------------------------------
                      return Card(
                        // Use a slight elevation and border for separation
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: levelColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),

                          // 💡 LEADING: Show colored icon indicating the severity
                          leading: CircleAvatar(
                            backgroundColor: levelColor.withValues(alpha: 0.2),
                            child: Icon(
                              Icons
                                  .local_hospital_outlined, // Relevant health icon
                              color: levelColor,
                            ),
                          ),

                          // 💡 TITLE: Emphasize the interpretation (Level) and color-code it
                          title: Text(
                            level,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: levelColor,
                            ),
                          ),

                          // 💡 SUBTITLE: Combine the ID and Score for quick reference
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score: ${score.toString()}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Record ID: ${id.toString()}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          // 💡 TRAILING: Keep the date clearly visible
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                dateString,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          onTap: () {
                            // Handle navigation to a detailed result screen
                            if (kDebugMode) {
                              print('Viewing details for ID: $id');
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HarsResultScreen(
                                  result:
                                      result, // Pass the AssessmentResult object
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            // Optional: Handle long press for additional actions
                            if (kDebugMode) {
                              print('Long pressed on ID: $id');
                            }
                            _showDeleteDialog(index, id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Utility function inside _ArticleScreenState (or a mixin/util class)
  Color _getLevelColor(String? level) {
    if (level == null) return Colors.grey;

    // Use lower-case comparison for robust parsing
    switch (level.toLowerCase()) {
      case 'mild anxiety':
        return Colors.green.shade400; // Calmer color for low anxiety
      case 'moderate anxiety':
        return Colors.orange.shade700; // Warning color
      case 'severe anxiety':
        return Colors.red.shade600; // Alert color
      default:
        return Colors.blueGrey;
    }
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

  void _showDeleteDialog(int index, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: Text('Are you sure you want to delete record ID $id?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteHistory(index, id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHistory(int index, int id) async {
    // TODO: Implement deletion logic here
  }
}
