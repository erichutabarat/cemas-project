class AssessmentResult {
  final int id;
  final int totalScore;
  final String anxietyLevel;
  final DateTime? createdAt;

  AssessmentResult({
    required this.id,
    required this.createdAt,
    required this.totalScore,
    required this.anxietyLevel,
  });

  // Factory constructor to create an AssessmentResult from a JSON map
  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'],
      totalScore: json['total_score'],
      anxietyLevel: json['anxiety_level'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Method to convert an AssessmentResult to a JSON map
  Map<String, dynamic> toJson() {
    return {'total_score': totalScore, 'anxiety_level': anxietyLevel};
  }

  Map<String, dynamic> toMap() {
    return {'score': totalScore, 'level': anxietyLevel};
  }

  @override
  String toString() {
    return 'AssessmentResult(id: $id, score: $totalScore, level: $anxietyLevel, date: $createdAt)';
  }
}
