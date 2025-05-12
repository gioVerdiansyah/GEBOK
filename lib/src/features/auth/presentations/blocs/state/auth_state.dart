import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final ApiState api;
  final AuthEntity user;

  AuthState({
    ApiState? api,
    AuthEntity? user,
  })  : api = api ?? ApiState(),
        user = user ?? AuthEntity.empty();

  AuthState copyWith({
    ApiState? api,
    AuthEntity? user,
  }) {
    return AuthState(
      api: api ?? this.api,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [api, user];
}
