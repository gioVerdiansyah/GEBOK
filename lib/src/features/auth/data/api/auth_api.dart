import 'package:book_shelf/env.dart';
import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/src/core/network/api_path.dart';
import 'package:book_shelf/src/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  final ApiClient _api;

  AuthApi(this._api);

  Future<AuthModel> login() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      forceCodeForRefreshToken: true,
      scopes: ["email", "${Env.BASE_URL}${ApiPath.login}"],
      clientId: Env.GOOGLE_CLIENT_ID,
    );

    final GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) {
      throw ApiException("Google login failed!", source: "AuthApi", details: "Account data is null!");
    }

    // print(account.displayName);
    // print(account.email);
    // print(account.photoUrl);
    // print(account.id);

    final auth = await account.authentication;
    final accessToken = auth.accessToken;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw ApiException("ID Token is null!", source: "AuthApi", details: "Maybe clientId is not set or incorrect.");
    }

    return AuthModel.fromJson({
      "id": account.id,
      "token": accessToken,
      "displayName": account.displayName,
      "email": account.email,
      "photoUrl": account.photoUrl,
    });
  }

  Future<void> logout(String token) async {
    await _api.post(
      ApiPath.logout,
      isExternalPath: true,
      options: Options(headers: {"application": "x-www-form-urlencoded"}),
      body: {"token": token},
    );
  }

  Future<AuthModel> checkToken(String token) async {
    final userInfo = await _api.get(Env.BASE_URL + ApiPath.checkToken, isExternalPath: true);
    return AuthModel.fromJson(userInfo.data);
  }
}
