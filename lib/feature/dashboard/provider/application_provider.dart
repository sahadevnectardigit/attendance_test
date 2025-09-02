import 'package:attendance/feature/dashboard/model/officail_visit_model.dart';
import 'package:attendance/feature/dashboard/repo/application_repo.dart';
import 'package:flutter/cupertino.dart';

class ApplicationProvider extends ChangeNotifier {
  List<OfficialVisitModel>? officialVisitModelList = [];
  bool isLoading = false;
  String? errorMessage = "";

  Future<void> fetchOfficialVisitData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ApplicationRepo.fetchOfficialVisitData();

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      officialVisitModelList = result.data;

      errorMessage = null;
    } else {
      officialVisitModelList = null;
      errorMessage =
          result.message ?? "Failed to load data"; // failure → string
    }

    notifyListeners();
  }

  // Future<bool> postApplication() async {
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();

  //   final result = await ProfileRepo.updateProfile(imageFile: imageFile);

  //   isLoading = false;

  //   if (result.isSuccess && result.data != null) {

  //     notifyListeners();
  //     return true;
  //   } else {
  //     errorMessage =
  //         result.message ?? "Failed to post application"; // failure → string
  //         notifyListeners();
  //     return false;
  //   }
  // }
}
