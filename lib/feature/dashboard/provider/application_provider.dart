import 'package:attendance/feature/dashboard/model/approve_recommended_model.dart';
import 'package:attendance/feature/dashboard/model/officail_visit_model.dart';
import 'package:attendance/feature/dashboard/repo/application_repo.dart';
import 'package:flutter/cupertino.dart';

class ApplicationProvider extends ChangeNotifier {
  ApproveRecommendModel? approveRecommendModel;
  bool isApproveLoading = false;
  String? errorApprove = '';

  List<OfficialVisitModel> officialVisitModelList = [];
  bool isOfficialLoading = false;
  String? errorMessageOfficial = "";

  bool isLoadingPostOfficial = false;
  String? errorOfficialPostMessage = '';

  bool isLoadingPostLateIn = false;
  String? errorLateInPostMessage = '';

  Future<bool> postLateInEarlyOut({
    required Map<String, dynamic> applicationData,
  }) async {
    isLoadingPostLateIn = true;
    errorLateInPostMessage = null;
    notifyListeners();

    final result = await ApplicationRepo.postLateInEarlyOut(
      applicationData: applicationData,
    );

    isLoadingPostLateIn = false;

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      errorLateInPostMessage =
          result.message ?? "Failed to post official visit"; // failure → string
      notifyListeners();
      return false;
    }
  }

  Future<bool> postOfficialVisit({
    required Map<String, dynamic> applicationData,
  }) async {
    isLoadingPostOfficial = true;
    errorOfficialPostMessage = null;
    notifyListeners();

    final result = await ApplicationRepo.postOfficialVisit(
      applicationData: applicationData,
    );

    isLoadingPostOfficial = false;

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      errorOfficialPostMessage =
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
    isOfficialLoading = true;
    errorMessageOfficial = null;
    notifyListeners();

    final result = await ApplicationRepo.fetchOfficialVisitData();

    isOfficialLoading = false;

    if (result.isSuccess && result.data != null) {
      officialVisitModelList = result.data!;

      errorMessageOfficial = null;
    } else {
      officialVisitModelList = [];
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
