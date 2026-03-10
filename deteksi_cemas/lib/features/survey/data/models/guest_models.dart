class Guest {
  final String name;
  final String email;
  final int age;
  final String prodi;
  final String nim;
  final String phoneNumber;

  Guest({
    required this.name,
    required this.email,
    required this.age,
    required this.prodi,
    required this.nim,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'prodi': prodi,
      'nim': nim,
      'phone_number': phoneNumber,
    };
  }
}
