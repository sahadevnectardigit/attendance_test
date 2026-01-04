import 'dart:developer';

import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';

class SystemSettingProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<bool> systemSettingState = const ApiState.initial();

  Future<void> fetchSystemSettings() async {
    systemSettingState = const ApiState.loading();
    notifyListeners();

    // log('Params data in roster data:${params.toString()}');
    try {
      final response = await _client.get(path: ApiUrl.systemSetting);
      // log('System setting data............:${response.data.toString()}');
      if (response.statusCode == 200) {
        final res = response.data['enable_nepali_date'];

        systemSettingState = ApiState.success(res);
        // Check if days is null or empty

        notifyListeners();
      } else {
        systemSettingState = const ApiState.error(
          "Failed to fetch system setting",
        );
        CustomSnackbar.error(systemSettingState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      systemSettingState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(systemSettingState.error.toString());
      notifyListeners();
    } catch (e) {
      systemSettingState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(systemSettingState.error.toString());
      notifyListeners();
    }
  }
}
