class AssessmentResult {
  final int totalScore;
  final String anxietyLevel;

  AssessmentResult({required this.totalScore, required this.anxietyLevel});

  // Factory constructor to create an AssessmentResult from a JSON map
  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      totalScore: json['total_score'],
      anxietyLevel: json['anxiety_level'],
    );
  }

  // Method to convert an AssessmentResult to a JSON map
  Map<String, dynamic> toJson() {
    return {'total_score': totalScore, 'anxiety_level': anxietyLevel};
  }
}
