// auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

// Event ini akan dikirim saat tombol login ditekan
// Kita juga "membawa" data email dan password ke BLoC
class LoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
