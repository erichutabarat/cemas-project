class HarsQuestions {
  final int id;
  final String category;
  final String question;
  final String questionId; // Based on your JSON "Suasana hati cemas"
  final String symptomType;
  final List<HarsOptions> options;

  HarsQuestions({
    required this.id,
    required this.category,
    required this.question,
    required this.questionId,
    required this.symptomType,
    required this.options,
  });

  factory HarsQuestions.fromJson(Map<String, dynamic> json) {
    return HarsQuestions(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      questionId: json['question_id'],
      symptomType: json['symptom_type'],
      options: (json['options'] as List)
          .map((i) => HarsOptions.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'question_id': questionId,
      'symptom_type': symptomType,
      'options': options.map((i) => i.toJson()).toList(),
    };
  }
}

class HarsOptions {
  final int id;
  final int questionId;
  final String option;
  final String optionId; // Based on your JSON "Perasaan cemas..."
  final int score;

  HarsOptions({
    required this.id,
    required this.questionId,
    required this.option,
    required this.optionId,
    required this.score,
  });

  factory HarsOptions.fromJson(Map<String, dynamic> json) {
    return HarsOptions(
      id: json['id'],
      questionId: json['question_id'],
      option: json['option'],
      optionId: json['option_id'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'option': option,
      'option_id': optionId,
      'score': score,
    };
  }
}
