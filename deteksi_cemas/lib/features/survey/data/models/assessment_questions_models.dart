import 'package:deteksi_cemas/features/survey/data/models/question_options_model.dart';

class AssessmentQuestion {
  final int id;
  final String category;
  final String question;
  final String questionId;
  final String symptomType;
  final List<QuestionOption> options; // ADDED THIS

  AssessmentQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.symptomType,
    required this.questionId,
    required this.options, // ADDED THIS
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      symptomType: json['symptom_type'],
      questionId: json['question_id'],
      // ADDED: Mapping the options list from JSON
      options: (json['options'] as List)
          .map((optionJson) => QuestionOption.fromJson(optionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'symptom_type': symptomType,
      'question_id': questionId,
      'options': options.map((opt) => opt.toJson()).toList(), // ADDED THIS
    };
  }
}
