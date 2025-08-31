import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _requestsQueue = [];

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.tattendance,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip adding token for auth endpoints
          if (options.path.contains('login') ||
              options.path.contains('refresh')) {
            return handler.next(options);
          }

          final token = await LocalStorage.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Only handle 401 errors for non-auth endpoints
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('login') &&
              !e.requestOptions.path.contains('refresh')) {
            // Add request to queue if we're already refreshing
            if (_isRefreshing) {
              _requestsQueue.add(e.requestOptions);
              return handler.next(e);
            }

            _isRefreshing = true;
            final refreshed = await _refreshToken();

            if (refreshed) {
              // Retry the original request
              final retryRequest = e.requestOptions;
              final newToken = await LocalStorage.getAccessToken();
              retryRequest.headers["Authorization"] = "Bearer $newToken";

              try {
                final response = await dio.fetch(retryRequest);
                _isRefreshing = false;

                // Process any queued requests
                _processQueue();

                return handler.resolve(response);
              } catch (retryError) {
                _isRefreshing = false;
                // Convert Object to DioException if needed
                if (retryError is DioException) {
                  _clearQueueWithError(retryError);
                } else {
                  // Create a DioException from the error
                  _clearQueueWithError(
                    DioException(
                      requestOptions: e.requestOptions,
                      error: retryError,
                      message: retryError.toString(),
                    ),
                  );
                }
                return handler.next(e);
              }
            } else {
              // Refresh failed → logout and clear queue
              _isRefreshing = false;
              await LocalStorage.clearTokens();
              _clearQueueWithError(e);

              // Navigate to login page
              _navigateToLogin();
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _processQueue() async {
    if (_requestsQueue.isEmpty) return;

    final newToken = await LocalStorage.getAccessToken();
    final failedRequests = <RequestOptions>[];

    for (final requestOptions in _requestsQueue) {
      try {
        requestOptions.headers["Authorization"] = "Bearer $newToken";
        await dio.fetch(requestOptions);
      } catch (e) {
        failedRequests.add(requestOptions);
        if (kDebugMode) {
          print("Failed to retry queued request: $e");
        }
      }
    }

    _requestsQueue.clear();
    // Add failed requests back to queue or handle as needed
    if (failedRequests.isNotEmpty) {
      _requestsQueue.addAll(failedRequests);
    }
  }

  void _clearQueueWithError(DioException error) {
    for (final request in _requestsQueue) {
      // You might want to notify listeners about failed requests
    }
    _requestsQueue.clear();
  }

  void _navigateToLogin() {
    // Use a global key or event bus to navigate to login
    // This is a simplified approach - you might need to adjust based on your app structure
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigatorKey = GlobalKey<NavigatorState>();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AttendanceLoginPage()),
        (route) => false,
      );
    });
  }

  /// Enhanced refresh token logic
  static Future<bool> _refreshToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final refreshDio = Dio(BaseOptions(baseUrl: ApiUrl.tattendance));

      final response = await refreshDio.post(
        ApiUrl.refreshToken,
        data: {"refresh": refreshToken},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken =
            response.data['access'] ?? response.data['access_token'];
        final newRefreshToken =
            response.data['refresh'] ?? response.data['refresh_token'];

        if (accessToken != null) {
          await LocalStorage.saveTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken ?? refreshToken,
          );
          return true;
        }
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          "Refresh token failed: ${e.response?.statusCode} - ${e.response?.data}",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Refresh token failed: $e");
      }
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
