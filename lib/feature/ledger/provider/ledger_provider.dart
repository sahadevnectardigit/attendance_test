import 'package:attendance/feature/ledger/repo/ledger_repo.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class LedgerProvider extends ChangeNotifier {
  LedgerModel? ledgerModel;
  String? errorMessage;
  bool isLoading = false;

  Future<bool> fetchLedgerData({int? year, int? month}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await LedgerRepo.fetchLedgerData(month: month, year: year);

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      ledgerModel = result.data;
      notifyListeners();
      errorMessage = null;
      return true;
    } else {
      ledgerModel = null;
      errorMessage =
          result.message ?? "Failed to load ledger data"; // failure → string

      notifyListeners();
      return false;
    }
  }

  // Helper method to get attendance status for a specific date
  String? getAttendanceStatus(String date) {
    if (ledgerModel?.detailData == null) return null;

    for (var detail in ledgerModel!.detailData!) {
      if (detail.date == date) {
        return detail.remarks;
      }
    }

    return null;
  }

  ///Helper method to get attendance day name for a specific date
  String? getAttendanceDay(String date) {
    if (ledgerModel?.detailData == null) return null;

    for (var detail in ledgerModel!.detailData!) {
      if (detail.date == date) {
        return detail.day;
      }
    }

    return null;
  }

  // Get all dates from the API response
  List<String> getAllDates() {
    if (ledgerModel?.detailData == null) return [];
    return ledgerModel!.detailData!.map((detail) => detail.date).toList();
  }
}

extension LedgerProviderExtension on LedgerProvider {
  String getDayName(String date) {
    if (ledgerModel?.detailData == null) return '';

    for (var detail in ledgerModel!.detailData!) {
      if (detail.date == date) {
        return detail.day;
      }
    }

    return '';
  }
}

//!Old one
// class LedgerProvider extends ChangeNotifier {
//   LedgerModelTesting? ledgerModel; // model
//   String? errorMessage; // string error

//   bool isLoading = false;

//   Future<bool> fetchLedgerData({int? year, int? month}) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     final result = await LedgerRepo.fetchLedgerData(month: month, year: year);

//     isLoading = false;

//     if (result.isSuccess && result.data != null) {
//       ledgerModel = result.data;
//       notifyListeners();
//       errorMessage = null;
//       return true;
//     } else {
//       ledgerModel = null;
//       errorMessage =
//           result.message ?? "Failed to ledger data"; // failure → string

//       notifyListeners();
//       return false;
//     }
//   }
// }
