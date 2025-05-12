import '../../../env.dart';

class ApiConfig {
  static String apiUrl = Env.API_URL;
  static String apiKey = Env.API_KEY;
  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;
}