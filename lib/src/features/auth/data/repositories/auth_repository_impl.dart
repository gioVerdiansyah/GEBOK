import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/auth/data/api/auth_api.dart';
import 'package:book_shelf/src/features/auth/data/models/auth_model.dart';
import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final AuthLocal _local;

  AuthRepositoryImpl(this._api) : _local = AuthLocal();

  @override
  Future<AuthEntity> login() async {
    try {
      final res = await _api.login();

      await _local.saveAuthData(token: res.token!);

      await _local.saveLoginType("google");

      return res.toEntity();
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      throw RepositoryException(
        e.toString(),
        stackTrace: stackTrace,
        source: "AuthRepositoryImpl",
        details: "May failed while save auth token.",
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      if(_local.getLoginType() == "google"){
        final token = _local.getToken();
        if(token == null) throw Exception("Token tidak ditemukan");
        await _api.logout(_local.getToken()!);
      }

      await _local.clearAuthData();
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      throw RepositoryException(
        e.toString(),
        stackTrace: stackTrace,
        source: "AuthRepositoryImpl",
        details: "May failed while save auth token.",
      );
    }
  }

  @override
  Future<AuthEntity?> checkToken(String token) async {
    try {
      final AuthModel res = await _api.checkToken(token);
      return res.toEntity();
    } catch (e, stackTrace) {
      throw RepositoryException(
        (e is ApiException && e.statusCode == 401) ? "Sesi telah berakhir silahkan login kembali" : e.toString(),
        stackTrace: stackTrace,
        source: "AuthRepositoryImpl",
        details: "May failed while check token.",
      );
    }
  }

  @override
  Future<void> loginAsGuest() async {
    await _local.saveLoginType("guest");
  }
}
