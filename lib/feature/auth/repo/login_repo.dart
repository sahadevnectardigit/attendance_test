import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/auth_api_client.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_response_model.dart';
import 'package:dio/dio.dart';

class LoginRepo {
  static final AuthApiClient _authClient = AuthApiClient();

  static Future<ApiResponse<void>> login({
    required String email,
    required String password,
    required String companyCode,
  }) async {
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

      if (response.statusCode == 200) {
        await LocalStorage.saveTokens(
          accessToken: data['access_token'] ?? "",
          refreshToken: data['refresh_token'] ?? "",
        );
        return ApiResponse.success(null); // ✅ success
      } else {
        return ApiResponse.failure(data["error"] ?? "Login failed");
      }
    } on DioException catch (e) {
      final backendMessage = e.response?.data?["error"];
      if (backendMessage != null) {
        return ApiResponse.failure(backendMessage);
      }
      return ApiResponse.failure(ApiErrorHandler.handleError(e));
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }
}
