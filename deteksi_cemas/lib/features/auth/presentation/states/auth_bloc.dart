// auth_bloc.dart
import 'package:deteksi_cemas/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// Asumsi path file repository Anda

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // 1. Deklarasikan variabel untuk menampung Repository
  final AuthRepository authRepository;

  // 2. Terima AuthRepository di constructor
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit state LOADING saat proses dimulai
    emit(AuthLoading());

    try {
      // 2. Panggil fungsi API Login dari Repository
      // Fungsi ini akan melempar (throw) Exception jika login gagal (401)
      final List<String> response = await authRepository.loginUser(
        event.email,
        event.password,
      );

      // 3. Jika pemanggilan sukses (tidak melempar Exception), emit state SUKSES
      // Anda bisa memasukkan token ke dalam AuthSuccess jika perlu
      emit(AuthSuccess(token: response[0], name: response[1]));
    } on Exception catch (e) {
      // 4. Jika terjadi Exception (baik 401 atau masalah jaringan), emit state ERROR
      // Gunakan pesan error dari Exception
      emit(AuthError(e.toString().replaceFirst("Exception: ", "")));
    } catch (e) {
      // Menangkap error lain yang tidak terduga
      emit(AuthError("Terjadi kesalahan tak terduga: ${e.toString()}"));
    }
  }
}
