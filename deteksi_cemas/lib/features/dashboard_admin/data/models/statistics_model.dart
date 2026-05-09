class StatisticsModel {
  int totalUsers;
  int totalInspections;
  int totalHarsResponses;
  int totalHarsQuestions;

  StatisticsModel({
    required this.totalUsers,
    required this.totalInspections,
    required this.totalHarsResponses,
    required this.totalHarsQuestions,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalUsers: json['total_users'] ?? 0,
      totalInspections: json['total_inspections'] ?? 0,
      totalHarsResponses: json['total_hars_results'] ?? 0,
      totalHarsQuestions: json['total_hars_questions'] ?? 0,
    );
  }

  Map toJson() {
    return {
      'total_users': totalUsers,
      'total_inspections': totalInspections,
      'total_hars_responses': totalHarsResponses,
      'total_hars_questions': totalHarsQuestions,
    };
  }
}
