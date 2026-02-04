class QuestionOption {
  final int id;
  final int questionId;
  final String option;
  final String optionId; // This is the Indonesian translation field
  final int score;

  QuestionOption({
    required this.id,
    required this.questionId,
    required this.option,
    required this.optionId,
    required this.score,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      questionId: json['question_id'],
      option: json['option'],
      optionId: json['option_id'],
      score: json['score'] ?? 0,
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
