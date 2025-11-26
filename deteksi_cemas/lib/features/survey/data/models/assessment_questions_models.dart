class AssessmentQuestion {
  final int id;
  final String category;
  final String question;
  final String symptomType;

  AssessmentQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.symptomType,
  });

  // Factory constructor to create an AssessmentQuestion from a JSON map
  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      symptomType: json['symptom_type'],
    );
  }

  // Method to convert an AssessmentQuestion to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'symptom_type': symptomType,
    };
  }
}
