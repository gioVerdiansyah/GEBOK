import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:book_shelf/src/features/auth/presentations/blocs/state/auth_state.dart';
import 'package:book_shelf/src/shared/state/api_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthState());

  Future<void> loginAsGuest() async {
    repo.loginAsGuest();
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      final AuthEntity result = await repo.login();

      emit(state.copyWith(api: state.api.success(), user: result));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }

  Future<void> checkToken(String token) async {
    try {
      emit(state.copyWith(api: state.api.loading()));

      final AuthEntity? result = await repo.checkToken(token);

      emit(state.copyWith(api: state.api.success(), user: result));
    } on ApiException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    } on RepositoryException catch (e) {
      emit(state.copyWith(api: state.api.errorException(e)));
    }
  }
}
