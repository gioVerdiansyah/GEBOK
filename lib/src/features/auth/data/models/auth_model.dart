import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  final String? token;

  AuthModel({
    required this.token,
    required super.displayName,
    required super.email,
    required super.photoUrl,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    token: json['token'],
    displayName: json['displayName'] ?? json["name"],
    email: json['email'],
    photoUrl: json['photoUrl'] ?? json["picture"],
  );

  AuthEntity toEntity() {
    return AuthEntity(
        displayName: displayName,
        email: email,
        photoUrl: photoUrl
    );
  }
}