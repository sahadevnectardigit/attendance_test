import 'package:attendance/feature/profile/repo/profile_repo.dart';
import 'package:attendance/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? profileModel; // model
  String? errorMessage; // string error

  bool isLoading = false;

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
}
