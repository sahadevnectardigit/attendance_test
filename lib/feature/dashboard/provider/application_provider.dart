import 'package:attendance/feature/dashboard/model/approve_recommended_model.dart';
import 'package:attendance/feature/dashboard/model/officail_visit_model.dart';
import 'package:attendance/feature/dashboard/repo/application_repo.dart';
import 'package:flutter/cupertino.dart';

class ApplicationProvider extends ChangeNotifier {
  ApproveRecommendModel? approveRecommendModel;
  bool isApproveLoading = false;
  String? errorApprove = '';

  List<OfficialVisitModel>? officialVisitModelList = [];
  bool isLoading = false;
  String? errorMessageOfficial = "";

  String? errorMessage = '';

  Future<bool> postOfficialVisit({
    required Map<String, dynamic> applicationData,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await ApplicationRepo.postOfficialVisit(
      applicationData: applicationData,
    );

    isLoading = false;

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      errorMessage =
          result.message ?? "Failed to post official visit"; // failure → string
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchApproveData() async {
    isApproveLoading = true;
    errorApprove = null;
    notifyListeners();

    final result = await ApplicationRepo.fetchApproveRecommendedData();

    isApproveLoading = false;

    if (result.isSuccess && result.data != null) {
      approveRecommendModel = result.data;
      errorApprove = null;
    } else {
      approveRecommendModel = null;
      errorApprove =
          result.message ?? "Failed to load data"; // failure → string
    }

    notifyListeners();
  }

  Future<void> fetchOfficialVisitData() async {
    isLoading = true;
    errorMessageOfficial = null;
    notifyListeners();

    final result = await ApplicationRepo.fetchOfficialVisitData();

    isLoading = false;

    if (result.isSuccess && result.data != null) {
      officialVisitModelList = result.data;

      errorMessageOfficial = null;
    } else {
      officialVisitModelList = null;
      errorMessageOfficial =
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
