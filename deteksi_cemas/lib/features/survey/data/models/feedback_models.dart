import 'dart:convert';

enum QuestionType {
  scale,
  text,
  unknown;

  static QuestionType fromString(String value) {
    return QuestionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => QuestionType.unknown,
    );
  }
}

class FeedbackQuestion {
  final int id;
  final String text;
  final String category;
  final QuestionType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedbackQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a model from JSON
  factory FeedbackQuestion.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestion(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String,
      type: QuestionType.fromString(json['type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Method to convert model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Helper function to parse a list of questions
List<FeedbackQuestion> feedbackQuestionsFromJson(String str) =>
    List<FeedbackQuestion>.from(
      json.decode(str).map((x) => FeedbackQuestion.fromJson(x)),
    );
