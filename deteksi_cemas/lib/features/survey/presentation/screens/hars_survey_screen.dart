// ignore_for_file: deprecated_member_use

import 'package:deteksi_cemas/features/survey/data/models/answer_requests_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
// NOTE: Assuming HarsQuestionsRepository is correctly imported here
import 'package:deteksi_cemas/features/survey/data/repository/hars_questions.dart';
import 'package:deteksi_cemas/features/survey/domain/calculate_anxiety_score.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HarsSurveyScreen extends StatefulWidget {
  // Inject the repository via the constructor
  final HarsQuestionsRepository? surveyRepository;
  const HarsSurveyScreen({super.key, this.surveyRepository});

  @override
  State<HarsSurveyScreen> createState() => _HarsSurveyScreenState();
}

class _HarsSurveyScreenState extends State<HarsSurveyScreen> {
  List<AssessmentQuestion>? _questions;
  // Initialize _answers as empty until questions are loaded
  List<AnswerRequests> _answers = [];
  bool _isLoading = true;
  bool _hasError = false; // Added error state flag

  int _currentQuestionIndex = 0;

  final List<String> _scoreLabels = [
    "0: Not present",
    "1: Mild",
    "2: Moderate",
    "3: Severe",
    "4: Very Severe / Incapacitating",
  ];

  @override
  void initState() {
    super.initState();
    // Only call loadQuestions in initState
    _loadQuestions();
    // We remove _initializeAnswers() here because it depends on _questions being non-null.
  }

  Future<void> _loadQuestions() async {
    try {
      final fetchedQuestions = await widget.surveyRepository
          ?.fetchHarsQuestions();

      setState(() {
        _questions = fetchedQuestions;
        // 1. Initialize answers ONLY after questions are successfully loaded
        _initializeAnswers();
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true; // Set error flag
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load questions: $e')));
      }
    }
  }

  // 2. Initialize answers using the loaded _questions! list
  void _initializeAnswers() {
    if (_questions != null) {
      _answers = _questions!
          .map((question) => AnswerRequests(questionId: question.id, score: -1))
          .toList();
    }
    // If _questions is null, _answers remains [] (from initial definition)
  }

  void _previousQuestion() {
    if (_questions == null || _isLoading) return; // Safety check

    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
    // Safety check: Cannot proceed if loading, in error state, or no questions
    if (_questions == null || _isLoading || _hasError) return;

    // Check if an answer has been selected for the current question
    if (_answers[_currentQuestionIndex].score == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer to proceed.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Prevent moving forward without an answer
    }

    // 3. Removed incorrect re-initialization of _answers here!

    if (_currentQuestionIndex < _questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Last question, submit survey
      _submitSurvey();
    }
  }

  void _submitSurvey() {
    if (_questions == null || _isLoading) return;

    if (kDebugMode) {
      print('Submitting survey with answers:');
    }

    // Calculation requires non-null _questions list to pass to getAnxietyLevel
    String anxietyLevel = getAnxietyLevel(calculateTotalScore(), _questions!);

    AssessmentResult finalResult = AssessmentResult(
      totalScore: calculateTotalScore(),
      anxietyLevel: anxietyLevel,
    );

    // Use pushReplacement to prevent user from going back to the survey
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HarsResultScreen(result: finalResult),
      ),
    );
  }

  int calculateTotalScore() {
    if (_questions == null) return 0; // Safety check

    int total = 0;
    for (var answer in _answers) {
      if (answer.score != -1) {
        total += answer.score;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // 4. Handle Loading and Error states gracefully
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
              const Text(
                'Failed to load questions or no questions available.',
                textAlign: TextAlign.center,
              ),
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

    // Now we can safely use _questions!
    final AssessmentQuestion currentQuestion =
        _questions![_currentQuestionIndex];

    final int? currentSelectedScore =
        _answers[_currentQuestionIndex].score == -1
        ? null
        : _answers[_currentQuestionIndex].score;

    final bool isFirstQuestion = _currentQuestionIndex == 0;
    final bool isLastQuestion = _currentQuestionIndex == _questions!.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HARS Survey'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Text(
                    "Question ${_currentQuestionIndex + 1} of ${_questions!.length}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions!.length,
                    backgroundColor: Colors.grey.shade300,
                    color: Theme.of(context).primaryColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Question Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentQuestion.question,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 24),

                        // Answer Options
                        Expanded(
                          child: ListView.builder(
                            itemCount: _scoreLabels.length,
                            itemBuilder: (context, index) {
                              return RadioListTile<int>(
                                value: index,
                                groupValue: currentSelectedScore,
                                onChanged: (int? value) {
                                  if (value != null) {
                                    setState(() {
                                      _answers[_currentQuestionIndex].score =
                                          value;
                                    });
                                  }
                                },
                                title: Text(
                                  _scoreLabels[index],
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                contentPadding: EdgeInsets.zero,
                                activeColor: Theme.of(context).primaryColor,
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
            const SizedBox(height: 20),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isFirstQuestion ? null : _previousQuestion,
                      child: const Text(
                        "Previous",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _nextQuestion,
                      child: Text(
                        isLastQuestion ? "Submit Survey" : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
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
