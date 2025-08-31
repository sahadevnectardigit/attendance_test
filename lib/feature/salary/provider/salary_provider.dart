import 'package:attendance/feature/salary/repo/salary_repo.dart';
import 'package:attendance/models/salary_model.dart';
import 'package:flutter/material.dart';

class SalaryProvider extends ChangeNotifier {
  SalaryModel? salaryModel; // model
  String? errorMessage; // string error

  bool isLoading = false;

  Future<void> fetchSalary() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final result = await SalaryRepo.fetchSalaryData();
    isLoading = false;

    if (result.isSuccess && result.data != null) {
      salaryModel = result.data;
      errorMessage = null;
    } else {
      salaryModel = null;
      errorMessage =
          result.message ?? "Failed to load salary data"; // failure → string
    }

    notifyListeners();
  }
}
