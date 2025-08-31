import 'dart:io';

import 'package:attendance/feature/profile/repo/profile_repo.dart';
import 'package:attendance/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  LedgerModel? profileModel;
  String? errorMessage;
  String? errorProfileUpdate;
  String? errorChangePassword;

  bool isLoading = false;

  Future<bool> changePassword({required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ProfileRepo.changePassword(password: password);

    isLoading = false;

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      errorChangePassword =
          result.message ?? "Failed to change password"; // failure → string
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfileData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ProfileRepo.fetchProfileData();

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      profileModel = result.data;
      errorMessage = null;
    } else {
      profileModel = null;
      errorMessage =
          result.message ?? "Failed to load profile"; // failure → string
    }

    notifyListeners();
  }

  Future<bool> updateProfileImagge({File? imageFile}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ProfileRepo.updateProfile(imageFile: imageFile);

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      errorMessage = null;
      notifyListeners();
      return true;
    } else {
      errorProfileUpdate =
          result.message ?? "Failed to update profile"; // failure → string
      notifyListeners();
      return false;
    }
  }
}
