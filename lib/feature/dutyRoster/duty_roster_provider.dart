import 'dart:developer';

import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/dutyRoster/duty_roster_model.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';

class DutyRosterProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<DutyRosterResponse> dutyRosterState = const ApiState.initial();

  Future<void> fetchDutyRoster() async {
    log('at roster.......................');
    dutyRosterState = const ApiState.loading();
    notifyListeners();
    final params = {"year": 2025, "month": 12, "person": 2};
    try {
      final response = await _client.get(
        path: ApiUrl.dutyRoster,
        queryParameters: params,
      );
      if (response.statusCode == 200) {
        final model = DutyRosterResponse.fromJson(response.data);
        dutyRosterState = ApiState.success(model);
        notifyListeners();
      } else {
        dutyRosterState = const ApiState.error("Failed to fetch duty data");
        CustomSnackbar.error(dutyRosterState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      dutyRosterState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(dutyRosterState.error.toString());
      notifyListeners();
    } catch (e) {
      dutyRosterState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(dutyRosterState.error.toString());
      notifyListeners();
    }
  }
}
