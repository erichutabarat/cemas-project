// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard/domain/repository/user_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_survey_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/get_icon_level.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleScreen extends StatefulWidget {
  final ScrollController? controller;
  const ArticleScreen({super.key, this.controller});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final UserRepository userRepository = UserRepository();
  late Future<List<dynamic>> userHistoryFuture;

  @override
  void initState() {
    super.initState();
    userHistoryFuture = userRepository.fetchUsersSurveyHistory();
  }

  // --- REFRESH LOGIC ---
  Future<void> _refreshHistory() async {
    setState(() {
      // Re-fetching the data triggers the FutureBuilder to rebuild
      userHistoryFuture = userRepository.fetchUsersSurveyHistory();
    });
    // Wait for the future to complete before hiding the spinner
    await userHistoryFuture;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // 1. Wrap the scrollable area with RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        color: ColorList.aquaCyan, // Optional: matches your theme
        child: SingleChildScrollView(
          // 2. Ensure it's ALWAYS scrollable so pull-to-refresh works even when empty
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Header ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorList.aquaCyan,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
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
              const SizedBox(height: 12),

              // --- Info Card ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildInfoCard(context),
              ),

              // --- Start Button ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors
                          .green
                          .shade800, // Changes the background color to green
                      foregroundColor: Colors
                          .white, // Changes the text and icon color (optional)
                    ),
                    onPressed: () => startSurvey(context),
                    icon: const Icon(Icons.psychology_alt),
                    label: Text(
                      l10n.start_survey,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),

              // --- History Section ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  l10n.survey_history,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              FutureBuilder<List<dynamic>>(
                future: userHistoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final List<dynamic> historyData = snapshot.data ?? [];

                  if (historyData.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'No history records found.\nPull down to refresh.',
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: historyData.length,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Handled by SingleChildScrollView
                      itemBuilder: (context, index) {
                        final item = historyData[index];
                        final int id = item['ID'];
                        final int score = item['score'];
                        final String level = item['level'];
                        final Color levelColor = _getLevelColor(level);
                        final DateTime? createdAt = item['CreatedAt'] != null
                            ? DateTime.tryParse(item['CreatedAt'])
                            : null;

                        final String dateString = createdAt != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(createdAt.toLocal())
                            : 'N/A';

                        final AssessmentResult result = AssessmentResult(
                          id: id,
                          totalScore: score,
                          anxietyLevel: level,
                          createdAt: createdAt,
                        );

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: levelColor.withAlpha(128),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: levelColor.withAlpha(50),
                              child: Icon(
                                getIconLevel(level),
                                color: levelColor,
                              ),
                            ),
                            title: Text(
                              level,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: levelColor,
                              ),
                            ),
                            subtitle: Text('Score: $score\nID: $id'),
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
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => responsiveLayout(
                                  content: HarsResultScreen(result: result),
                                ),
                              ),
                            ),
                            onLongPress: () => _showDeleteDialog(index, id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 50), // Extra space at bottom for scrolling
            ],
          ),
        ),
      ),
    );
  }

  // Utility function inside _ArticleScreenState (or a mixin/util class)
  Color _getLevelColor(String? level) {
    if (level == null) return Colors.grey;

    // Use lower-case comparison for robust parsing
    switch (level.toLowerCase()) {
      case 'normal':
        return Colors.green.shade500; // Calmer color for low anxiety
      case 'mild anxiety':
        return Colors.yellow.shade700; // Warning color for mild anxiety
      case 'moderate anxiety':
        return Colors.orange.shade700; // Warning color
      case 'severe anxiety':
        return Colors.red.shade600; // Alert color
      case 'very serious anxiety':
        return Colors.red.shade800; // Stronger alert color
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.what_is_hars,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(l10n.hars_desc),
            const SizedBox(height: 12),
            Text(
              l10n.hars_disclaimer,
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
    // 1. Show a loading indicator (optional but recommended)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting record...'),
        duration: Duration(milliseconds: 500),
      ),
    );

    try {
      // 2. Perform the API deletion
      await userRepository.deleteSurveyResultByID(id);

      // 3. Refresh the FutureBuilder
      setState(() {
        // Re-assigning the future triggers the FutureBuilder to run again
        userHistoryFuture = userRepository.fetchUsersSurveyHistory();
      });

      // 4. Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully')),
      );
    } catch (e) {
      // 5. Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.toString()}')),
      );
    }
  }
}
