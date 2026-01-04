import 'dart:developer';

import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/auth_api_client.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/main.dart' as MainApiClient;
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  static final AuthApiClient _authClient = AuthApiClient();

  ApiState<void> loginState = const ApiState.initial();

  Future<bool> login({
    required String email,
    required String password,
    required String companyCode,
    bool rememberMe = false, // Add rememberMe parameter
  }) async {
    loginState = const ApiState.loading();
    notifyListeners();

    try {
      final loginData = {
        "username": email,
        "company_code": companyCode,
        "password": password,
      };
      // log('LongIn: $loginData');
      final response = await _authClient.post(
        path: ApiUrl.login,
        data: loginData,
      );
      // log('LongIn Response: ${response.data}');

      final data = response.data;
      log("Token: ${data['access_token']}");

      if (response.statusCode == 200) {
        // final model = LoginResponse.fromJson(response.data);
        // loginState = ApiState.success(model);
        // Save tokens
        await LocalStorage.saveTokens(
          accessToken: data['access_token'] ?? "",
          refreshToken: data['refresh_token'] ?? "",
        );

        // Save remember me preference
        await LocalStorage.setRememberMe(rememberMe);

        // Optionally save user credentials if remember me is enabled
        if (rememberMe) {
          await LocalStorage.saveUserCredentials(
            email: email,
            companyCode: companyCode,
            // Note: Don't save password for security reasons
          );
        } else {
          // Clear saved credentials if remember me is disabled
          await LocalStorage.clearUserCredentials();
        }

        // loginState = const ApiState.success(null);
        notifyListeners();
        return true; // API succeeded
      } else {
        loginState = ApiState.error(data["error"] ?? "Login failed");
        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      final backendMessage = e.response?.data?["detail"];
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

  // Method to logout and clear all stored data
  Future<void> logout() async {
    try {
      // Clear tokens and remember me preference
      await LocalStorage.clearTokens();
      await LocalStorage.clearRememberMe();
      await LocalStorage.clearUserCredentials();

      // Reset login state
      loginState = const ApiState.initial();
      notifyListeners();

      // Navigate to login page
      if (MainApiClient.navigatorKey.currentState != null) {
        MainApiClient.navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      log("Error during logout: $e");
    }
  }

  // Method to get saved user credentials for auto-fill
  Future<Map<String, String?>> getSavedCredentials() async {
    try {
      final email = await LocalStorage.getSavedEmail();
      final companyCode = await LocalStorage.getSavedCompanyCode();
      return {'email': email, 'companyCode': companyCode};
    } catch (e) {
      log("Error getting saved credentials: $e");
      return {'email': null, 'companyCode': null};
    }
  }
}
// class LoginProvider extends ChangeNotifier {
//   static final AuthApiClient _authClient = AuthApiClient();

//   ApiState<void> loginState = const ApiState.initial();

//   Future<bool> loginn({
//     required String email,
//     required String password,
//     required String companyCode,
//   }) async {
//     loginState = const ApiState.loading();
//     notifyListeners();

//     try {
//       final loginData = {
//         "username": email,
//         "password": password,
//         "company_code": companyCode,
//       };

//       final response = await _authClient.post(
//         path: ApiUrl.login,
//         data: loginData,
//       );

//       final data = response.data;
//       log("Token: ${data['access_token']}");

//       if (response.statusCode == 200) {
//         await LocalStorage.saveTokens(
//           accessToken: data['access_token'] ?? "",
//           refreshToken: data['refresh_token'] ?? "",
//         );
//         loginState = const ApiState.success(null);
//         notifyListeners();
//         return true; // API succeeded
//       } else {
//         loginState = ApiState.error(data["error"] ?? "Login failed");
//         notifyListeners();
//         return false; // API failed
//       }
//     } on DioException catch (e) {
//       final backendMessage = e.response?.data?["error"];
//       if (backendMessage != null) {
//         loginState = ApiState.error(backendMessage);
//       } else {
//         loginState = ApiState.error(ApiErrorHandler.handleError(e));
//       }
//       notifyListeners();
//       return false;
//     } catch (e) {
//       loginState = ApiState.error("Unexpected error: $e");
//       notifyListeners();
//       return false;
//     }
//   }
// }
