import 'package:attendance/feature/dashboard/model/dashboard_model.dart';
import 'package:attendance/feature/dashboard/repo/employee_repo.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  DashBoardModel? dashboard; // model
  String? errorMessage; // string error

  bool isLoading = false;

  Future<void> fetchDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await DashboardRepo.getDashboardData();

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      dashboard = result.data;
      errorMessage = null;
    } else {
      dashboard = null;
      errorMessage =
          result.message ?? "Failed to load dashboard"; // failure → string
    }

    notifyListeners();
  }
}
