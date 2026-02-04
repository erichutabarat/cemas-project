// ignore_for_file: deprecated_member_use

import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/domain/calculate_anxiety_score.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HarsSurveyScreen extends StatefulWidget {
  final HarsQuestionsRepository? surveyRepository;
  const HarsSurveyScreen({super.key, this.surveyRepository});

  @override
  State<HarsSurveyScreen> createState() => _HarsSurveyScreenState();
}

class _HarsSurveyScreenState extends State<HarsSurveyScreen> {
  List<AssessmentQuestion>? _questions;

  // Stores selected option IDs for each question index
  // Format: { questionIndex: [optionId1, optionId2, ...] }
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
          ?.fetchHarsQuestions();
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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load questions: $e')));
      }
    }
  }

  void _previousQuestion() {
    if (_questions == null || _isLoading) return;
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_questions == null || _isLoading || _hasError) return;

    // VALIDATION: Check if user has selected at least one option for the current question
    final currentSelections = _selectedOptionIds[_currentQuestionIndex] ?? [];
    if (currentSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseselect),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentQuestionIndex < _questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
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
        // Find the option object that matches the selected ID to get its score
        final option = question.options.firstWhere((opt) => opt.id == id);
        total += option.score;
      }
    });
    return total;
  }

  void _submitSurvey() {
    if (_questions == null || _isLoading) return;

    final int totalScore = _calculateTotalScore();
    final String anxietyLevel = getAnxietyLevel(totalScore, _questions!);

    AssessmentResult finalResult = AssessmentResult(
      totalScore: totalScore,
      anxietyLevel: anxietyLevel,
      id: -1,
      createdAt: null,
    );

    widget.surveyRepository
        ?.fetchHarsSubmit(finalResult)
        .then((success) {
          if (kDebugMode) {
            print(success ? 'Survey submitted' : 'Submission failed');
          }
        })
        .catchError((error) {
          if (kDebugMode) print('Submission error: $error');
        });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HarsResultScreen(result: finalResult),
      ),
    );
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
        appBar: AppBar(title: const Text('HARS Survey')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load questions.'),
              const SizedBox(height: 20),
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

    // Get the list of selected IDs for the current view
    final List<int> selectedIds =
        _selectedOptionIds[_currentQuestionIndex] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HARS Survey'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Text(
                    "${l10n.questionLabel} ${_currentQuestionIndex + 1} ${l10n.textOf} ${_questions!.length}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions!.length,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            // Question & Options Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentLocale == "en"
                              ? currentQuestion.question
                              : currentQuestion.questionId,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.selectapply,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(height: 30),

                        // Options List
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentQuestion.options.length,
                            itemBuilder: (context, index) {
                              final option = currentQuestion.options[index];
                              final bool isSelected = selectedIds.contains(
                                option.id,
                              );

                              return CheckboxListTile(
                                title: Text(
                                  currentLocale == "en"
                                      ? option.option
                                      : option.optionId,
                                ),
                                value: isSelected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Theme.of(context).primaryColor,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (bool? checked) {
                                  setState(() {
                                    if (checked == true) {
                                      // Initialize list if it doesn't exist for this question
                                      _selectedOptionIds.putIfAbsent(
                                        _currentQuestionIndex,
                                        () => [],
                                      );
                                      _selectedOptionIds[_currentQuestionIndex]!
                                          .add(option.id);
                                    } else {
                                      _selectedOptionIds[_currentQuestionIndex]!
                                          .remove(option.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isFirstQuestion ? null : _previousQuestion,
                      child: Text(l10n.previous),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _nextQuestion(context),
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
}
