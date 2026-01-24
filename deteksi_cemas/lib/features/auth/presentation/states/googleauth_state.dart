abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final String token;
  final String name;
  final String email;

  GoogleAuthSuccess({
    required this.token,
    required this.name,
    required this.email,
  });
}

class GoogleAuthNeedsRegistration extends GoogleAuthState {
  final String email;
  final String name;

  GoogleAuthNeedsRegistration({required this.email, required this.name});
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;
  GoogleAuthFailure(this.error);
}
