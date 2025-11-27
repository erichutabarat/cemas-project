import 'package:equatable/equatable.dart';

// Abstract class utama
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

// State Awal: Saat halaman baru dibuka
class AuthInitial extends AuthState {}

// State Loading: Saat tombol login ditekan, sebelum ada hasil
class AuthLoading extends AuthState {}

// State Sukses: Jika login berhasil
class AuthSuccess extends AuthState {
  final String token;
  final String name;

  const AuthSuccess({required this.token, required this.name});
  @override
  List<Object> get props => [token, name];
}

// State Error: Jika login gagal
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
