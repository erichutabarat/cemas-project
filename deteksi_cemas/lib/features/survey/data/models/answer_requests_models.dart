class AnswerRequests {
  final int questionId;
  late int score;

  AnswerRequests({required this.questionId, required this.score});

  // Factory constructor to create an AnswerRequest from a JSON map
  factory AnswerRequests.fromJson(Map<String, dynamic> json) {
    return AnswerRequests(
      questionId: json['question_id'],
      score: json['score'],
    );
  }

  // Method to convert an AnswerRequest to a JSON map
  Map<String, dynamic> toJson() {
    return {'question_id': questionId, 'score': score};
  }

  @override
  String toString() {
    return "AnswerRequests(questionId: $questionId, score: $score)";
  }
}
