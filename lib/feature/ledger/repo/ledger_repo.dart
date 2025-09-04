import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_state.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:dio/dio.dart';

class LedgerRepo {
  static final MainApiClient _client = MainApiClient();

  static Future<ApiResponse<LedgerModel?>> fetchLedgerData({
    int? year,
    int? month,
  }) async {
    try {
      final params = {"year": year, "month": month};
      final response = await _client.get(
        path: ApiUrl.ledger,
        queryParameters: params,
      );

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
}
