import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/dio_interceptor.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_response_model.dart';
import 'package:attendance/models/profile_model.dart';
import 'package:dio/dio.dart';

class ProfileRepo {
  static final ApiClient _client = ApiClient();

  static Future<ApiResponse<ProfileModel>> fetchProfileData() async {
    try {
      final response = await _client.get(path: ApiUrl.profile);

      if (response.statusCode == 200) {
        final model = ProfileModel.fromJson(response.data);
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
}
