class AuthEntity {
  final String displayName;
  final String email;
  final String photoUrl;

  AuthEntity({
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  factory AuthEntity.empty() {
    return AuthEntity(
      displayName: '',
      email: '',
      photoUrl: '',
    );
  }
}