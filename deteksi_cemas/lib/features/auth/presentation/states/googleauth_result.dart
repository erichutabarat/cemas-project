class GoogleAuthResult {
  final bool isRegistered;
  final String?
  token; // This stays nullable because new users don't have a token yet
  final String name; // Removed the '?'
  final String email; // Removed the '?'

  GoogleAuthResult({
    required this.isRegistered,
    required this.name,
    required this.email,
    this.token,
  });
}
