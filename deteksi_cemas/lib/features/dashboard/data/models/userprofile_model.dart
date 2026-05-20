class UserProfile {
  final int id;
  final String name;
  final String email;
  final String gender;
  final DateTime birthdate;
  final String? address;
  final String? job;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthdate,
    this.address,
    this.job,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      address: json['address'],
      job: json['job'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'birthdate':
          '${birthdate.year.toString().padLeft(4, '0')}-'
          '${birthdate.month.toString().padLeft(2, '0')}-'
          '${birthdate.day.toString().padLeft(2, '0')}', // ← YYYY-MM-DD only
      'address': address,
      'job': job,
    };
  }
}
