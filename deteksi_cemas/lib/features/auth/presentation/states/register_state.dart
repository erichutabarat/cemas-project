abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String name;
  final int userId;

  RegisterSuccess({
    required this.message,
    required this.name,
    required this.userId,
  });
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
