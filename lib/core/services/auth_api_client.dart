import 'package:attendance/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthApiClient {
  static final AuthApiClient _instance = AuthApiClient._internal();
  factory AuthApiClient() => _instance;

  late Dio dio;

  AuthApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.tattendance,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    // Simple interceptor for auth requests only
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print("Auth API Request: ${options.method} ${options.path}");
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print("Auth API Error: ${error.response?.statusCode} - ${error.message}");
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// POST for authentication
  Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post(path, data: data, queryParameters: queryParameters);
  }

  /// GET for authentication (if needed)
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }
}