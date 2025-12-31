import 'dart:developer';

import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/dutyRoster/duty_roster_model.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';

class DutyRosterProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<DutyRosterResponse> dutyRosterState = const ApiState.initial();

  Future<void> fetchDutyRoster({bool nepaliEnabled = false}) async {
    // log('Duty roster nepaliEnabledValue: $nepaliEnabled');
    int yearData;
    int monthData;
    if (nepaliEnabled) {
      yearData = NepaliDateTime.now().year;
      monthData = NepaliDateTime.now().month;
    } else {
      yearData = DateTime.now().year;
      monthData = DateTime.now().month;
    }

    dutyRosterState = const ApiState.loading();
    notifyListeners();
    // final params = {"year": 2025, "month": 12, "person": 2};
    // final params = {"year": 2082, "month": 09, "person": 2};
    final params = {
      "year": yearData, "month": monthData, // "person": 2
    };

    // log('Params data in roster data:${params.toString()}');
    try {
      final response = await _client.get(
        path: ApiUrl.dutyRoster,
        queryParameters: params,
      );
      log('Duty roster reponse:${response.data.toString()}');
      if (response.statusCode == 200) {
        final model = DutyRosterResponse.fromJson(response.data);
        dutyRosterState = ApiState.success(model);
        // Check if days is null or empty
        final daysData = response.data['roster_data']?['days'];
        final bool hasNoData =
            daysData == null ||
            (daysData is Map && daysData.isEmpty) ||
            (daysData is List && daysData.isEmpty);
        if (hasNoData) {
          // Show "No data found" message
          dutyRosterState = const ApiState.error("No duty roster data found");
          CustomSnackbar.error("No duty roster data found");
        } else {
          dutyRosterState = ApiState.success(model);
        }
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
