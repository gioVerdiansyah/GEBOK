import 'package:book_shelf/src/core/config/api_config.dart';
import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/core/exceptions/api_exception.dart';
import 'package:book_shelf/src/core/exceptions/validation_exception.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/shared/constants/storage_key_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

class ApiClient {
  late final Dio _dio;
  final String baseUrl = ApiConfig.apiUrl;
  static bool _initialized = false;
  final VoidCallback? onUnauthorized;

  // Initialize GetStorage
  static Future<void> init() async {
    if (!_initialized) {
      await GetStorage.init();
      _initialized = true;
    }
  }

  ApiClient({this.onUnauthorized}) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(seconds: ApiConfig.connectTimeout),
        headers: {'Accept': 'application/json'},
        validateStatus: (status) {
          return status != null && (status >= 200 && status < 300);
        },
      ),
    );


    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final unusedAuth = options.extra['unusedAuth'] as bool? ?? false;

          if (!unusedAuth) {
            final token = AuthLocal().getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } else {
            options.headers.remove('Authorization');
          }

          return handler.next(options);
        },
      ),
    );
  }

  // New method to clean body data
  dynamic _cleanBody(dynamic body) {
    if (body == null) return null;

    if (body is Map<String, dynamic>) {
      final cleanedMap = <String, dynamic>{};

      body.forEach((key, value) {
        if (value != null && (value is! String || value.trim().isNotEmpty)) {
          cleanedMap[key] = value;
        }
      });

      return cleanedMap;
    }

    return body;
  }

  Future<dynamic> _processIfUpdateFile(dynamic body) async {
    if (body == null) return null;

    if (body is! Map<String, dynamic>) return body;

    bool hasFiles = false;
    final formMap = <String, dynamic>{};

    Future<List<MultipartFile>> processMultipleFiles(List<PlatformFile> files) async {
      return Future.wait(files.map((file) => MultipartFile.fromFile(file.path!, filename: file.name)));
    }

    Future<MultipartFile> processSingleFile(PlatformFile file) async {
      final mimeType = lookupMimeType(file.path!) ?? 'application/octet-stream';
      final mediaType = DioMediaType.parse(mimeType);

      return MultipartFile.fromFile(file.path!, filename: file.name, contentType: mediaType);
    }

    final cleanedBody = _cleanBody(body) as Map<String, dynamic>?;
    if (cleanedBody == null) return null;

    for (var entry in cleanedBody.entries) {
      final value = entry.value;

      try {
        if (value is List<PlatformFile>) {
          hasFiles = true;
          if (value.length == 1) {
            formMap[entry.key] = await processSingleFile(value.first);
          } else {
            formMap[entry.key] = await processMultipleFiles(value);
          }
        } else if (value is PlatformFile) {
          hasFiles = true;
          formMap[entry.key] = await processSingleFile(value);
        } else if (value != null) {
          if (value is List) {
            for (var item in value) {
              formMap.putIfAbsent("${entry.key}[]", () => []).add(item.toString());
            }
          } else {
            formMap[entry.key] = value.toString();
          }
        }
      } catch (e) {
        print('Error processing field ${entry.key}: $e');
        rethrow;
      }
    }
    print("===== REQUEST BODY =====");
    print(formMap);

    return hasFiles ? FormData.fromMap(formMap) : cleanedBody;
  }

  // GET Request
  Future<Response> get(
    String path, {
    bool isExternalPath = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool unusedAuth = false,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.extra = {...requestOptions.extra ?? {}, 'unusedAuth': unusedAuth};

      // Clean query parameters if they exist
      final cleanedParams = queryParameters != null ? (_cleanBody(queryParameters) as Map<String, dynamic>?) : null;

      final response = await _dio.get(
        isExternalPath ? path : baseUrl + path,
        queryParameters: cleanedParams,
        options: requestOptions,
      );

      // if (response.statusCode == 422) {
      //   return response;
      // }

      return response;
    } on DioException catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'get', path);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    bool isExternalPath = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool unusedAuth = false,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.extra = {...requestOptions.extra ?? {}, 'unusedAuth': unusedAuth};

      final processedBody = await _processIfUpdateFile(body);

      if (processedBody is FormData) {
        requestOptions.headers = {...requestOptions.headers ?? {}, 'Content-Type': 'multipart/form-data'};
      }

      // Clean query parameters if they exist
      final cleanedParams = queryParameters != null ? (_cleanBody(queryParameters) as Map<String, dynamic>?) : null;

      final response = await _dio.post(
        isExternalPath ? path : baseUrl + path,
        data: processedBody,
        queryParameters: cleanedParams,
        options: requestOptions,
      );
      return response;
    } on DioException catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'get', path);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    bool isExternalPath = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool unusedAuth = false,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.extra = {...requestOptions.extra ?? {}, 'unusedAuth': unusedAuth};

      final cleanedBody = _cleanBody(body);
      final cleanedParams = queryParameters != null ? (_cleanBody(queryParameters) as Map<String, dynamic>?) : null;

      final response = await _dio.put(
        isExternalPath ? path : baseUrl + path,
        data: cleanedBody,
        queryParameters: cleanedParams,
        options: requestOptions,
      );
      return response;
    } on DioException catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'get', path);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    bool isExternalPath = false,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool unusedAuth = false,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.extra = {...requestOptions.extra ?? {}, 'unusedAuth': unusedAuth};

      final cleanedBody = _cleanBody(body);
      final cleanedParams = queryParameters != null ? (_cleanBody(queryParameters) as Map<String, dynamic>?) : null;

      final response = await _dio.delete(
        isExternalPath ? path : baseUrl + path,
        data: cleanedBody,
        queryParameters: cleanedParams,
        options: requestOptions,
      );
      return response;
    } on DioException catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'get', path);
    }
  }

  // Error Handler
  Exception _handleError(DioException error, StackTrace stackTrace, String apiMethod, String path) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout');
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
          case 403:
          case 404:
          case 500:
            return ApiException(
              error.response?.data?['message'] ?? error.response?.data?['error']?['message'],
              // requestId: error.response?.data?['data']?["request_id"],
              source: "ApiClient",
              details: "Error while fetching api at \n${apiMethod.toUpperCase()} : $path",
              stackTrace: stackTrace,
              statusCode: error.response?.statusCode,
            );
          case 422:
            print("====== ERROR VALIDATION ======");
            print(error.response?.data?['data']);
            return ValidationException(error.response?.data?['data']);
          case 401:
            onUnauthorized?.call();
            getIt<AuthLocal>().clearAuthData();
            return ApiException(
              error.response?.data?['error'],
              // requestId: error.response?.data?['data']["request_id"],
              // details: error.response?.data?['data']["error"],
              source: "ApiClient",
              details: "Error while fetching api at \n${apiMethod.toUpperCase()} : $path",
              stackTrace: stackTrace,
              statusCode: error.response?.statusCode,
            );
          default:
            return ApiException(
              "Ada kesalahan server...",
              // requestId: error.response?.data?['data']["request_id"],
              // details: error.response?.data?['data']["error"],
              source: "ApiClient",
              details: "Error while fetching api at \n${apiMethod.toUpperCase()} : $path",
              stackTrace: stackTrace,
              statusCode: error.response?.statusCode,
            );
        }

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      default:
        return ApiException('Gagal melakukan koneksi :(');
    }
  }
}
