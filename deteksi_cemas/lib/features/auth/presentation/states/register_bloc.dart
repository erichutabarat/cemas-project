import 'package:deteksi_cemas/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final authRepository = AuthRepository();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      if (event.password != event.confirmPassword) {
        emit(RegisterFailure("Passwords do not match."));
        return;
      }
      if (event.password.length < 6) {
        emit(RegisterFailure("Password must be at least 6 characters long."));
        return; // Stop here, don't call the API
      }
      emit(RegisterLoading());

      try {
        final data = await authRepository.registerUser(
          name: event.name,
          email: event.email,
          password: event.password,
          birthDate: event.birthDate,
          gender: event.gender,
        );

        emit(
          RegisterSuccess(
            message: data['message'],
            name: data['name'],
            userId: data['user_id'],
          ),
        );
      } catch (e) {
        String errorMessage = e.toString().replaceAll("Exception: ", "");

        // Map the key from repository to a friendly UI message
        if (errorMessage == "password_too_short") {
          errorMessage =
              "Password is too short. Please use at least 8 characters.";
        } else if (errorMessage.contains("Email already registered")) {
          errorMessage = "This email is already in use.";
        }

        emit(RegisterFailure(errorMessage));
      }
    });
  }
}
