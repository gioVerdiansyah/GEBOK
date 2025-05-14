import 'package:book_shelf/src/shared/constants/storage_key_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class AuthLocal {
  final GetStorage _storage = GetStorage();

  Future<void> saveAuthData({required String token}) async {
    debugPrint("=== SAVED TOKEN ===");
    debugPrint(token);
    await Future.wait([_storage.write(StorageKeyConstant.tokenKey, token)]);
  }

  Future<void> saveLoginType(String loginType) async {
    await _storage.write(StorageKeyConstant.loginType, loginType);
  }

  Future<void> clearAuthData() async {
    await _storage.remove(StorageKeyConstant.tokenKey);
    await _storage.remove(StorageKeyConstant.loginType);
  }

  String? getToken() => _storage.read(StorageKeyConstant.tokenKey);
  String? getLoginType() => _storage.read(StorageKeyConstant.loginType);
}
