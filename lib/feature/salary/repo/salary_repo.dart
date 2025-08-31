import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/dio_interceptor.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_response_model.dart';
import 'package:attendance/models/salary_model.dart';
import 'package:dio/dio.dart';

class SalaryRepo {
  static final ApiClient _client = ApiClient();

  static Future<ApiResponse<List<SalaryModel>>> fetchSalaryData() async {
    try {
      final response = await _client.get(path: ApiUrl.employeeSalary);
      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data;
        final listModel = dataList
            .map((item) => SalaryModel.fromJson(item))
            .toList();

        return ApiResponse.success(listModel); // returns model on success
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
