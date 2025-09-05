import 'dart:developer';

import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/auth_api_client.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  static final AuthApiClient _authClient = AuthApiClient();

  ApiState<void> loginState = const ApiState.initial();

  Future<bool> loginn({
    required String email,
    required String password,
    required String companyCode,
  }) async {
    loginState = const ApiState.loading();
    notifyListeners();

    try {
      final loginData = {
        "username": email,
        "password": password,
        "company_code": companyCode,
      };

      final response = await _authClient.post(
        path: ApiUrl.login,
        data: loginData,
      );

      final data = response.data;
      log("Token: ${data['access_token']}");

      if (response.statusCode == 200) {
        await LocalStorage.saveTokens(
          accessToken: data['access_token'] ?? "",
          refreshToken: data['refresh_token'] ?? "",
        );
        loginState = const ApiState.success(null);
        notifyListeners();
        return true; // API succeeded
      } else {
        loginState = ApiState.error(data["error"] ?? "Login failed");
        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      final backendMessage = e.response?.data?["error"];
      if (backendMessage != null) {
        loginState = ApiState.error(backendMessage);
      } else {
        loginState = ApiState.error(ApiErrorHandler.handleError(e));
      }
      notifyListeners();
      return false;
    } catch (e) {
      loginState = ApiState.error("Unexpected error: $e");
      notifyListeners();
      return false;
    }
  }
}
