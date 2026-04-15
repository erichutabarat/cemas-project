// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/guest_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/domain/calculate_anxiety_score.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/guest_hars_result_screen.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GuestHarsSurveyScreen extends StatefulWidget {
  final HarsQuestionsRepository? surveyRepository;
  final Guest guest;
  const GuestHarsSurveyScreen({
    super.key,
    this.surveyRepository,
    required this.guest,
  });

  @override
  State<GuestHarsSurveyScreen> createState() => _GuestHarsSurveyScreenState();
}

class _GuestHarsSurveyScreenState extends State<GuestHarsSurveyScreen> {
  List<AssessmentQuestion>? _questions;

  // Custom Colors
  final Color primaryDark = const Color(0xFF1A237E);
  final Color accentColor = const Color(0xFF3949AB);
  final Color bgColor = const Color(0xFFF8FAFC);

  final Map<int, List<int>> _selectedOptionIds = {};

  bool _isLoading = true;
  bool _hasError = false;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final fetchedQuestions = await widget.surveyRepository
          ?.fetchHarsQuestionsGuest(); // Use the guest method
      setState(() {
        _questions = fetchedQuestions;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _previousQuestion() {
    if (_questions == null || _isLoading) return;
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
    }
  }

  void _nextQuestion(BuildContext context) {
    if (_questions == null || _isLoading || _hasError) return;
    if (_currentQuestionIndex < _questions!.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _submitSurvey();
    }
  }

  int _calculateTotalScore() {
    if (_questions == null) return 0;
    int total = 0;
    _selectedOptionIds.forEach((questionIndex, selectedIds) {
      final question = _questions![questionIndex];
      for (var id in selectedIds) {
        final option = question.options.firstWhere((opt) => opt.id == id);
        total += option.score;
      }
    });
    return total;
  }

  void _submitSurvey() {
    if (_questions == null || _isLoading) return;
    final int totalScore = _calculateTotalScore();
    final String anxietyLevel = getAnxietyLevel(totalScore);

    AssessmentResult finalResult = AssessmentResult(
      totalScore: totalScore,
      anxietyLevel: anxietyLevel,
      id: -1,
      createdAt: null,
    );

    widget.surveyRepository?.fetchHarsSubmitGuest(
      guest: widget.guest,
      score: finalResult.totalScore,
      level: finalResult.anxietyLevel,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GuestHarsResultScreen(result: finalResult, guest: widget.guest),
      ),
    );
  }

  // Helper method properly placed INSIDE the State class
  void _toggleOption(int optionId) {
    setState(() {
      _selectedOptionIds.putIfAbsent(_currentQuestionIndex, () => []);
      if (_selectedOptionIds[_currentQuestionIndex]!.contains(optionId)) {
        _selectedOptionIds[_currentQuestionIndex]!.remove(optionId);
      } else {
        _selectedOptionIds[_currentQuestionIndex]!.add(optionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions == null || _hasError || _questions!.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load questions.'),
              ElevatedButton(
                onPressed: _loadQuestions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions![_currentQuestionIndex];
    final bool isFirstQuestion = _currentQuestionIndex == 0;
    final bool isLastQuestion = _currentQuestionIndex == _questions!.length - 1;
    final List<int> selectedIds =
        _selectedOptionIds[_currentQuestionIndex] ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      body: responsiveLayout(
        content: Column(
          children: [
            // 1. Fixed Header (Mimics SliverAppBar)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primaryDark, accentColor]),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Center(
                child: Text(
                  "HARS Survey",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 2. Main Scrollable Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Progress Info
                    Text(
                      "${l10n.questionLabel} ${_currentQuestionIndex + 1} ${l10n.textOf} ${_questions!.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions!.length,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentLocale == "en"
                                ? currentQuestion.question
                                : currentQuestion.questionId,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.selectapply,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(),
                          ),

                          // Options List (No ListView needed, just a Column of Widgets)
                          ...currentQuestion.options.map((option) {
                            final bool isSelected = selectedIds.contains(
                              option.id,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => _toggleOption(option.id),
                                borderRadius: BorderRadius.circular(16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? accentColor
                                          : Colors.grey.shade200,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    color: isSelected
                                        ? accentColor.withOpacity(0.08)
                                        : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle_rounded
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? accentColor
                                            : Colors.grey[400],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          currentLocale == "en"
                                              ? option.option
                                              : option.optionId,
                                          style: TextStyle(
                                            color: isSelected
                                                ? primaryDark
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Navigation Bar (Fixed at bottom)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (!isFirstQuestion)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 56),
                          side: BorderSide(color: accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.previous,
                          style: TextStyle(color: accentColor),
                        ),
                      ),
                    ),
                  if (!isFirstQuestion) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _nextQuestion(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isLastQuestion ? l10n.submitsurvey : l10n.next,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} // Final closing brace for the State class
