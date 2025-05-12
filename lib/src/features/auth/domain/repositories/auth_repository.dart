import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login();
  Future<AuthEntity?> checkToken(String token);
}