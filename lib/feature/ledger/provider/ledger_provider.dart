import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_state.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';

class LedgerProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<LedgerModel> fetchLedgerState = const ApiState.initial();

  Future<bool> fetchLedgerData({int? year, int? month}) async {
    fetchLedgerState = const ApiState.loading();
    notifyListeners();

    try {
      final params = {"year": year, "month": month};
      final response = await _client.get(
        path: ApiUrl.ledger,
        queryParameters: params,
      );
      if (response.statusCode == 200) {
        final model = LedgerModel.fromJson(response.data);

        fetchLedgerState = ApiState.success(model);
        notifyListeners();
        return true;
      } else {
        fetchLedgerState = const ApiState.error("Failed to fetch ledger data");
        CustomSnackbar.error(fetchLedgerState.error.toString());
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      fetchLedgerState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchLedgerState.error.toString());
      notifyListeners();
      return true;
    } catch (e) {
      fetchLedgerState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchLedgerState.error.toString());
      notifyListeners();
      return true;
    }
  }

  // Helper method to get attendance status for a specific date
  String? getAttendanceStatus(String date) {
    if (fetchLedgerState.data?.detailData == null) return null;

    for (var detail in fetchLedgerState.data?.detailData ?? []) {
      if (detail.date == date) {
        return detail.remarks;
      }
    }

    return null;
  }

  ///Helper method to get attendance day name for a specific date
  String? getAttendanceDay(String date) {
    if (fetchLedgerState.data?.detailData == null) return null;

    for (var detail in fetchLedgerState.data?.detailData ?? []) {
      if (detail.date == date) {
        return detail.day;
      }
    }

    return null;
  }

  // Get all dates from the API response
  List<String> getAllDates() {
    if (fetchLedgerState.data?.detailData == null) return [];
    return fetchLedgerState.data?.detailData
            ?.map((detail) => detail.date)
            .toList() ??
        [];
  }
}

extension LedgerProviderExtension on LedgerProvider {
  String getDayName(String date) {
    if (fetchLedgerState.data?.detailData == null) return '';

    for (var detail in fetchLedgerState.data?.detailData ?? []) {
      if (detail.date == date) {
        return detail.day;
      }
    }

    return '';
  }
}
