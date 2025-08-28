import 'package:attendance/feature/auth/repo/login_repo.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login({required String email, required String password,required String companyCode}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await LoginRepo.login(email: email, password: password,companyCode:companyCode);

    _isLoading = false;

    if (result.isSuccess) {
      notifyListeners();
      return true; // ✅ success
    } else {
      _errorMessage = result.message;
      notifyListeners();
      return false; // ❌ failure
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
