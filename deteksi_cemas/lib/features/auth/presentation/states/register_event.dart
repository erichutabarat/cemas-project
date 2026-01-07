abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final DateTime birthDate; // New
  final String gender; // New

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.birthDate,
    required this.gender,
  });
}
