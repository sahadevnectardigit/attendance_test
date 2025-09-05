import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/dashboard/model/dashboard_model.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';

class DashboardProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<DashBoardModel> fetchDashBoardState = const ApiState.initial();

  Future<void> fetchDashboardData() async {
    fetchDashBoardState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.dashboard);

      if (response.statusCode == 200) {
        final model = DashBoardModel.fromJson(response.data);
        fetchDashBoardState = ApiState.success(model);
        notifyListeners();
      } else {
        fetchDashBoardState = const ApiState.error(
          "Failed to fetch dashboard data",
        );
        CustomSnackbar.error(fetchDashBoardState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchDashBoardState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchDashBoardState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchDashBoardState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchDashBoardState.error.toString());
      notifyListeners();
    }
  }

}
