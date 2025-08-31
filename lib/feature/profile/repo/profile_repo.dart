import 'dart:io';

import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/dio_interceptor.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_response_model.dart';
import 'package:attendance/models/profile_model.dart';
import 'package:dio/dio.dart';

class ProfileRepo {
  static final ApiClient _client = ApiClient();

  static Future<ApiResponse<void>> changePassword({
    required String password,
  }) async {
    try {
      final response = await _client.post(
        path: ApiUrl.changePassword,
        data: {"new_password": password},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      } else {
        final errorList = response.data["new_password"];
        final errorMsg = (errorList is List && errorList.isNotEmpty)
            ? errorList.first
            : "Failed to change password";
        return ApiResponse.failure(errorMsg);
      }
    } on DioException catch (e) {
      final errorList = e.response?.data?["new_password"];
      final backendMessage = (errorList is List && errorList.isNotEmpty)
          ? errorList.first
          : ApiErrorHandler.handleError(e);
      return ApiResponse.failure(backendMessage);
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }

  static Future<ApiResponse<LedgerModel>> fetchProfileData() async {
    try {
      final response = await _client.get(path: ApiUrl.profile);

      if (response.statusCode == 200) {
        final model = LedgerModel.fromJson(response.data);
        return ApiResponse.success(model); // returns model on success
      } else {
        final errorMsg = response.data["error"] ?? "Failed to fetch dashboard";
        return ApiResponse.failure(errorMsg); // returns string on failure
      }
    } on DioException catch (e) {
      final backendMessage = e.response?.data?["error"];
      return ApiResponse.failure(
        backendMessage ?? ApiErrorHandler.handleError(e),
      );
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }

  static Future<ApiResponse<bool>> updateProfile({File? imageFile}) async {
    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile?.path ?? "",
          filename: imageFile?.path.split('/').last,
        ),
      });

      final response = await _client.post(
        path: ApiUrl.updateProfileImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        await fetchProfileData();
        return ApiResponse.success(true);
      } else {
        final errorData = response.data;
        final errorMsg = errorData["image"] != null
            ? errorData["image"][0]
            : errorData["error"] ?? "Failed to update profile";
        return ApiResponse.failure(errorMsg);
      }
    } on DioException catch (e) {
      final backendMessage =
          e.response?.data?["image"]?[0] ??
          e.response?.data?["error"] ??
          ApiErrorHandler.handleError(e);
      return ApiResponse.failure(backendMessage);
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }
}
