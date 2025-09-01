// Better queue management with Completer (Enhanced version)
import 'dart:async';

import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainApiClient {
  static final MainApiClient _instance = MainApiClient._internal();
  factory MainApiClient() => _instance;

  late Dio dio;
  bool _isRefreshing = false;
  final List<QueuedRequest> _requestQueue = [];

  static GlobalKey<NavigatorState>? navigatorKey;

  MainApiClient._internal() {
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
          final token = await LocalStorage.getAccessToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            if (_isRefreshing) {
              // Add to queue and wait
              final completer = Completer<Response>();
              _requestQueue.add(QueuedRequest(e.requestOptions, completer));

              try {
                final response = await completer.future;
                return handler.resolve(response);
              } catch (error) {
                return handler.next(e);
              }
            }

            _isRefreshing = true;
            final refreshed = await _refreshToken();

            if (refreshed) {
              try {
                final newToken = await LocalStorage.getAccessToken();
                e.requestOptions.headers["Authorization"] = "Bearer $newToken";
                final response = await dio.fetch(e.requestOptions);

                _isRefreshing = false;
                await _processQueue();

                return handler.resolve(response);
              } catch (retryError) {
                _isRefreshing = false;
                _clearQueueWithError();
                return handler.next(e);
              }
            } else {
              _isRefreshing = false;
              await _handleLogout();
              _clearQueueWithError();
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _processQueue() async {
    final newToken = await LocalStorage.getAccessToken();

    for (final queuedRequest in _requestQueue) {
      try {
        queuedRequest.requestOptions.headers["Authorization"] =
            "Bearer $newToken";
        final response = await dio.fetch(queuedRequest.requestOptions);
        queuedRequest.completer.complete(response);
      } catch (e) {
        queuedRequest.completer.completeError(e);
      }
    }

    _requestQueue.clear();
  }

  void _clearQueueWithError() {
    for (final queuedRequest in _requestQueue) {
      queuedRequest.completer.completeError(
        DioException(
          requestOptions: queuedRequest.requestOptions,
          message: 'Authentication failed',
        ),
      );
    }
    _requestQueue.clear();
  }

  Future<void> _handleLogout() async {
    await LocalStorage.clearTokens();

    if (navigatorKey?.currentState != null) {
      navigatorKey!.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

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
    } catch (e) {
      if (kDebugMode) {
        print("Refresh token failed: $e");
      }
    }
    return false;
  }

  // HTTP Methods
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.delete(path, data: data, queryParameters: queryParameters);
  }
}

class QueuedRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  QueuedRequest(this.requestOptions, this.completer);
}
