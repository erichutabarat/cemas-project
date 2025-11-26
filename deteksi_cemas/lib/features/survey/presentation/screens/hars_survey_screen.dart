// ignore_for_file: deprecated_member_use

import 'package:deteksi_cemas/features/survey/data/assessment_questions.dart';
import 'package:deteksi_cemas/features/survey/data/models/answer_requests_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/domain/calculate_anxiety_score.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Assuming AnswerRequests is the same as AnswerRequest from previous models.
// If not, please adjust the import and class name accordingly.

class HarsSurveyScreen extends StatefulWidget {
  const HarsSurveyScreen({super.key});

  @override
  State<HarsSurveyScreen> createState() => _HarsSurveyScreenState();
}

class _HarsSurveyScreenState extends State<HarsSurveyScreen> {
  final List<AssessmentQuestion> _questions = harsQuestions;
  late List<AnswerRequests> _answers; // Renamed for clarity and consistency
  int _currentQuestionIndex = 0; // Renamed for clarity

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
    _initializeAnswers();
  }

  void _initializeAnswers() {
    _answers = _questions
        .map((question) => AnswerRequests(questionId: question.id, score: -1))
        .toList();
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _nextQuestion() {
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

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Last question, submit survey
      _submitSurvey();
    }
  }

  void _submitSurvey() {
    // Here you would typically send _answers to your backend
    // For now, let's just print them and navigate back
    if (kDebugMode) {
      print('Submitting survey with answers:');
    }
    for (var answer in _answers) {
      if (kDebugMode) {
        print('Question ID: ${answer.questionId}, Score: ${answer.score}');
      }
    }

    // You might show a loading indicator here
    String anxietyLevel = getAnxietyLevel(calculateTotalScore(), _questions);
    if (kDebugMode) {
      print(anxietyLevel);
    }
    // Then navigate back to the previous screen (e.g., HarsSurveyLandingScreen)
    AssessmentResult finalResult = AssessmentResult(
      totalScore: calculateTotalScore(),
      anxietyLevel: anxietyLevel,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HarsResultScreen(result: finalResult),
      ),
    );
  }

  int calculateTotalScore() {
    int total = 0;
    for (var answer in _answers) {
      if (answer.score == -1) {
        continue;
      } else {
        total += answer.score;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // Access the current question
    final AssessmentQuestion currentQuestion =
        _questions[_currentQuestionIndex];
    // Access the current selected score for the current question
    final int? currentSelectedScore =
        _answers[_currentQuestionIndex].score == -1
        ? null
        : _answers[_currentQuestionIndex].score;

    final bool isFirstQuestion = _currentQuestionIndex == 0;
    final bool isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HARS Survey'),
        centerTitle: true,
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Match background for a clean look
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
                    "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Colors.grey.shade300,
                    color: Theme.of(
                      context,
                    ).primaryColor, // Use theme primary color
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Rounded progress bar
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
                      mainAxisSize:
                          MainAxisSize.min, // Use min size for the column
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
                          // Let the radio options take available space
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
                                contentPadding:
                                    EdgeInsets.zero, // Remove default padding
                                activeColor: Theme.of(
                                  context,
                                ).primaryColor, // Use theme primary color
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
                      onPressed:
                          _nextQuestion, // Logic handles validation and submission
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
