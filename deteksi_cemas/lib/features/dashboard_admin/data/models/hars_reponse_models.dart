class HarsResponse {
  final int id;
  final DateTime createdAt;
  final int guestId; // Changed from userId to guestId to match JSON
  final int score; // Changed from totalScore to score
  final String level;
  final Guest guest;

  HarsResponse({
    required this.id,
    required this.createdAt,
    required this.guestId,
    required this.score,
    required this.level,
    required this.guest,
  });

  factory HarsResponse.fromJson(Map<String, dynamic> json) {
    return HarsResponse(
      // Note the Capital 'ID' and 'CreatedAt' to match your specific JSON
      id: json['ID'] ?? 0,
      createdAt: DateTime.parse(
        json['CreatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      guestId: json['guest_id'] ?? 0,
      score: json['score'] ?? 0,
      level: json['level'] ?? "Unknown",
      guest: Guest.fromJson(json['guest'] ?? {}),
    );
  }
}

class Guest {
  final int id;
  final String name;
  final String email;
  final String gender;
  final int age;

  Guest({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] ?? 0,
      name: json['name'] ?? "No Name",
      email: json['email'] ?? "No Email",
      gender: json['gender'] ?? "N/A",
      age: json['age'] ?? 0,
    );
  }
}
