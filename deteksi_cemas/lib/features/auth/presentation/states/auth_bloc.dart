// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // State awalnya adalah AuthInitial
  AuthBloc() : super(AuthInitial()) {
    // Mendaftarkan handler untuk event 'LoginButtonPressed'
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  // Fungsi ini akan dipanggil setiap kali event LoginButtonPressed terjadi
  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit state LOADING saat proses dimulai
    emit(AuthLoading());

    try {
      // Simulasi delay panggilan ke backend (server)
      await Future.delayed(const Duration(seconds: 2));

      // --- INI LOGIKA IF/ELSE SEDERHANA ANDA ---
      if (event.email == "test" && event.password == "test") {
        // 2. Emit state SUKSES jika berhasil
        emit(AuthSuccess());
      } else {
        // 3. Emit state ERROR jika gagal
        emit(const AuthError("Email atau password Anda salah."));
      }
    } catch (e) {
      // Menangkap error jika ada masalah lain
      emit(AuthError("Terjadi kesalahan: ${e.toString()}"));
    }
  }
}
