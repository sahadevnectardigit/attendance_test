import 'dart:developer';

import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/api_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/custom_snackbar.dart';
import '../../../models/salary_model.dart';

class SalaryProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<List<SalaryModel>> fetchSalaryState = const ApiState.initial();

  Future<void> fetchSalary() async {
    fetchSalaryState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.employeeSalary);
      log('Salary response:${response.data.toString()}');

      if (response.statusCode == 200) {
        // Directly check if response.data is a List
        if (response.data is! List) {
          fetchSalaryState = ApiState.error('Unexpected response format');
          CustomSnackbar.error('Unexpected response format');
          notifyListeners();
          return;
        }

        final List<dynamic> dataList = response.data;

        if (dataList.isEmpty) {
          fetchSalaryState = ApiState.success([]);
          CustomSnackbar.info('No salary records found.');
        } else {
          final listModel = dataList
              .map((item) => SalaryModel.fromJson(item))
              .toList();
          fetchSalaryState = ApiState.success(listModel);
        }
        notifyListeners();
      } else {
        fetchSalaryState = ApiState.error(
          'Failed to load salary data. Status: ${response.statusCode}',
        );
        CustomSnackbar.error('Failed to load salary data.');
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchSalaryState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchSalaryState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchSalaryState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchSalaryState.error.toString());
      notifyListeners();
    }
  }
}

// class SalaryProvider extends ChangeNotifier {
//   static final MainApiClient _client = MainApiClient();

//   ApiState<List<SalaryModel>> fetchSalaryState = const ApiState.initial();

//   Future<void> fetchSalary() async {
//     final noDataFound = 'No salary record found.';
//     fetchSalaryState = const ApiState.loading();
//     notifyListeners();

//     try {
//       final response = await _client.get(path: ApiUrl.employeeSalary);
//       log('Salary response:${response.data.toString()}');
//       if (response.statusCode == 200) {
//         if (response.statusCode == 200 &&
//             response.data['message'].toString() != noDataFound) {
//           fetchSalaryState = ApiState.error(response.data['message']);
//           return CustomSnackbar.error(fetchSalaryState.error.toString());
//         }
//         final List<dynamic> dataList = response.data;
//         final listModel = dataList
//             .map((item) => SalaryModel.fromJson(item))
//             .toList();
//         fetchSalaryState = ApiState.success(listModel);
//         notifyListeners();
//       } else {
//         fetchSalaryState = ApiState.error(response.data['message']);
//         CustomSnackbar.error(fetchSalaryState.error.toString());
//         notifyListeners();
//       }
//     } on DioException catch (e) {
//       fetchSalaryState = ApiState.error(ApiErrorHandler.handleError(e));
//       CustomSnackbar.error(fetchSalaryState.error.toString());
//       notifyListeners();
//     } catch (e) {
//       fetchSalaryState = ApiState.error("Unexpected error: $e");
//       CustomSnackbar.error(fetchSalaryState.error.toString());
//       notifyListeners();
//     }
//   }
// }
