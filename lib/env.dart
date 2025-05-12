class Env {
  static const _basePath = String.fromEnvironment("BASE_URL");
  static const _apiPath = String.fromEnvironment("API_BOOK_URL");
  static const _apiKey = String.fromEnvironment("API_KEY");
  static const _clientId = String.fromEnvironment("GOOGLE_CLIENT_ID");

  static String get BASE_URL => _basePath;
  static String get API_URL => _basePath + _apiPath;
  static String get API_KEY => _apiKey;
  static String get GOOGLE_CLIENT_ID => _clientId;
}