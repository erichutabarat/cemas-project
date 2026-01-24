import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deteksi_cemas/features/auth/domain/repository/auth_repository.dart';
import 'package:deteksi_cemas/features/dashboard/domain/services/token_service.dart'; // Adjust path
import 'googleauth_event.dart';
import 'googleauth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final AuthRepository authRepository;
  final TokenStorageService tokenStorage = TokenStorageService();

  GoogleAuthBloc({required this.authRepository}) : super(GoogleAuthInitial()) {
    on<GoogleSignInPressed>((event, emit) async {
      emit(GoogleAuthLoading());
      try {
        final result = await authRepository.signInWithGoogle();

        if (result.isRegistered) {
          // 1. Save Token if it exists
          if (result.token != null) {
            await tokenStorage.saveToken(result.token!);
            // Guaranteed non-null email for static method
            await AuthRepository.rememberEmail(result.email);
          }

          // 2. Emit Success with guaranteed non-null strings
          emit(
            GoogleAuthSuccess(
              token: result.token ?? "",
              name: result.name, // If this still errors, use: result.name ?? "User"
              email:
                  result.email, // If this still errors, use: result.email ?? ""
            ),
          );
        } else {
          // 3. New user logic
          emit(
            GoogleAuthNeedsRegistration(email: result.email, name: result.name),
          );
        }
      } catch (e) {
        emit(GoogleAuthFailure(e.toString()));
      }
    });
  }
}
