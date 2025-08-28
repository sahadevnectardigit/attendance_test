import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.tattendance,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 5),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await LocalStorage.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired → try refresh
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the failed request with new token
              final retryRequest = e.requestOptions;
              final newToken = await LocalStorage.getAccessToken();
              retryRequest.headers["Authorization"] = "Bearer $newToken";

              final response = await dio.fetch(retryRequest);
              return handler.resolve(response);
            } else {
              // Refresh failed → logout
              await LocalStorage.clearTokens();
              print("Session expired. Please log in again.");
            }
          }
          return handler.next(e); // Forward error
        },
      ),
    );
  }

  /// Refresh token logic
  static Future<bool> _refreshToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await Dio().post(
        ApiUrl.refreshToken, // 👈 update endpoint if different
        data: {"refresh": refreshToken},
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await LocalStorage.saveTokens(
          accessToken: response.data['access_token'],
          refreshToken:
              response.data['refresh_token'] ??
              refreshToken, // keep old if not returned
        );
        return true;
      }
    } catch (e) {
      print("Refresh token failed: $e");
    }
    return false;
  }

  /// GET
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  /// POST
  Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post(path, data: data, queryParameters: queryParameters);
  }

  /// PUT
  Future<Response> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.put(path, data: data, queryParameters: queryParameters);
  }

  /// DELETE
  Future<Response> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
