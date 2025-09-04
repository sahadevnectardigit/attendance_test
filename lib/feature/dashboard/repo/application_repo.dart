import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/custom_snackbar.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/dashboard/model/approve_recommended_model.dart';
import 'package:attendance/feature/dashboard/model/officail_visit_model.dart';
import 'package:attendance/models/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ApplicationRepo {
  static final MainApiClient _client = MainApiClient();

  static Future<ApiResponse<bool>> createLeaveApplication({
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      final response = await _client.post(
        path: ApiUrl.createLeaveApplication,
        data: applicationData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse.success(true);
      } else {
        final errorList = response.data["detail"];
        final errorMsg = (errorList is List && errorList.isNotEmpty)
            ? errorList.first
            : "Failed to post leave application";
        return ApiResponse.failure(errorMsg);
      }
    } on DioException catch (e) {
      final errorList = e.response?.data?["detail"];
      final backendMessage = (errorList is List && errorList.isNotEmpty)
          ? errorList.first
          : ApiErrorHandler.handleError(e);
      return ApiResponse.failure(backendMessage);
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }

  static Future<ApiResponse<bool>> postLateInEarlyOut({
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      final response = await _client.post(
        path: ApiUrl.lateInEarlyOut,
        data: applicationData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse.success(true);
      } else {
        final errorList = response.data["detail"];
        final errorMsg = (errorList is List && errorList.isNotEmpty)
            ? errorList.first
            : "Failed to post official visit";
        return ApiResponse.failure(errorMsg);
      }
    } on DioException catch (e) {
      final errorList = e.response?.data?["detail"];
      final backendMessage = (errorList is List && errorList.isNotEmpty)
          ? errorList.first
          : ApiErrorHandler.handleError(e);
      return ApiResponse.failure(backendMessage);
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    }
  }

  static Future<ApiResponse<bool>> postOfficialVisit({
    required BuildContext? context,
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      // EasyLoading.show(status: "Loading...");
      context?.loaderOverlay.show();
      final response = await _client.post(
        path: ApiUrl.createOfficialVisitApplication,
        data: applicationData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        CustomSnackbar.success("Application created successfully!");

        return ApiResponse.success(true);
      } else {
        EasyLoading.showError("Error occured");

        final errorList = response.data["detail"];
        final errorMsg = (errorList is List && errorList.isNotEmpty)
            ? errorList.first
            : "Failed to post official visit";
        return ApiResponse.failure(errorMsg);
      }
    } on DioException catch (e) {
      final errorList = e.response?.data?["detail"];
      final backendMessage = (errorList is List && errorList.isNotEmpty)
          ? errorList.first
          : ApiErrorHandler.handleError(e);
      return ApiResponse.failure(backendMessage);
    } catch (e) {
      return ApiResponse.failure("Unexpected error: $e");
    } finally {
      // EasyLoading.dismiss();
      if (context?.loaderOverlay.visible ?? false) {
        context?.loaderOverlay.hide();
      }
    }
  }

  static Future<ApiResponse<ApproveRecommendModel>>
  fetchApproveRecommendedData() async {
    try {
      final response = await _client.get(path: ApiUrl.getApprover);

      if (response.statusCode == 200) {
        final model = ApproveRecommendModel.fromJson(response.data);
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

  static Future<ApiResponse<List<OfficialVisitModel>>>
  fetchOfficialVisitData() async {
    try {
      final response = await _client.get(path: ApiUrl.getOfficialVisitDropDown);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => OfficialVisitModel.fromJson(item))
            .toList();
        return ApiResponse.success(modelList); // returns model on success
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

  // static Future<ApiResponse<bool>> postApplication() async {
  //   try {
  //     final data = {};
  //     final response = await _client.post(path: ApiUrl.dashboard, data: data);

  //     if (response.statusCode == 200) {
  //       return ApiResponse.success(true);
  //     } else {
  //       final errorMsg = response.data["error"] ?? "Failed to post application";
  //       return ApiResponse.failure(errorMsg); // returns string on failure
  //     }
  //   } on DioException catch (e) {
  //     final backendMessage = e.response?.data?["error"];
  //     return ApiResponse.failure(
  //       backendMessage ?? ApiErrorHandler.handleError(e),
  //     );
  //   } catch (e) {
  //     return ApiResponse.failure("Unexpected error: $e");
  //   }
  // }
}
