import 'package:attendance/feature/ledger/repo/ledger_repo.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class LedgerProvider extends ChangeNotifier {
  LedgerModel? ledgerModel; // model
  String? errorMessage; // string error

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
          result.message ?? "Failed to ledger data"; // failure → string

      notifyListeners();
      return false;
    }
  }
}
