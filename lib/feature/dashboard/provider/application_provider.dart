import 'package:attendance/core/constants/api_constants.dart';
import 'package:attendance/core/services/custom_snackbar.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/feature/dashboard/model/approve_recommended_model.dart';
import 'package:attendance/feature/dashboard/model/officail_visit_model.dart';
import 'package:attendance/models/api_state.dart';
import 'package:attendance/models/latein_earlyout_app_list_model.dart';
import 'package:attendance/models/leave_application_list_model.dart';
import 'package:attendance/models/leave_type_model.dart';
import 'package:attendance/models/official_application_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ApplicationProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<List<LeaveTypeModel>> fetchLeaveTypeState = const ApiState.initial();
  ApiState<ApproveRecommendModel> fetchApproveState = const ApiState.initial();
  ApiState<List<OfficialVisitModel>> fetchOfficialState =
      const ApiState.initial();
  ApiState<void> postOfficialAppState = const ApiState.initial();
  ApiState<void> postLeaveAppState = const ApiState.initial();
  ApiState<void> postLateInAppState = const ApiState.initial();
  ApiState<List<OfficialApplicationListModel>> fetchOfficialAppListState =
      const ApiState.initial();
  ApiState<List<LeaveApplicationListModel>> fetchLeaveAppListState =
      const ApiState.initial();
  ApiState<List<LateInOutAppListModel>> fetchLateInAppListState =
      const ApiState.initial();

  Future<void> fetchLateInAppList() async {
    fetchLateInAppListState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(
        path: ApiUrl.getLateInEaryOutApplications,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => LateInOutAppListModel.fromJson(item))
            .toList();
        fetchLateInAppListState = ApiState.success(modelList);
        notifyListeners();
      } else {
        fetchOfficialAppListState = const ApiState.error(
          "Failed to fetch latein earlyout applications",
        );
        CustomSnackbar.error(fetchLateInAppListState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchLateInAppListState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchLateInAppListState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchLateInAppListState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchLateInAppListState.error.toString());
      notifyListeners();
    }
  }

  Future<void> fetchLeaveAppList() async {
    fetchLeaveAppListState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.getLeaveApplications);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => LeaveApplicationListModel.fromJson(item))
            .toList();
        fetchLeaveAppListState = ApiState.success(modelList);
        notifyListeners();
      } else {
        fetchOfficialAppListState = const ApiState.error(
          "Failed to fetch leave applications data",
        );
        CustomSnackbar.error(fetchLeaveAppListState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchLeaveAppListState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchLeaveAppListState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchLeaveAppListState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchLeaveAppListState.error.toString());
      notifyListeners();
    }
  }

  Future<void> fetchOfficialAppList() async {
    fetchOfficialAppListState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(
        path: ApiUrl.getOfficialVisitApplications,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => OfficialApplicationListModel.fromJson(item))
            .toList();
        fetchOfficialAppListState = ApiState.success(modelList);
        notifyListeners();
      } else {
        fetchOfficialAppListState = const ApiState.error(
          "Failed to fetch official applications data",
        );
        CustomSnackbar.error(fetchOfficialState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchOfficialAppListState = ApiState.error(
        ApiErrorHandler.handleError(e),
      );
      CustomSnackbar.error(fetchOfficialAppListState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchOfficialAppListState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchOfficialAppListState.error.toString());
      notifyListeners();
    }
  }

  Future<bool> createLeaveApplication({
    required BuildContext context,
    required Map<String, dynamic> applicationData,
  }) async {
    context.loaderOverlay.show();

    postLeaveAppState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.post(
        path: ApiUrl.createLeaveApplication,
        data: applicationData,
      );

      if (response.statusCode == 201) {
        fetchLeaveAppList();
        CustomSnackbar.success("Application created successfully!");
        notifyListeners();
        return true; // API succeeded
      } else {
        postLeaveAppState = const ApiState.error("Failed to create aplication");
        CustomSnackbar.error(postLeaveAppState.error.toString());

        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      postLeaveAppState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(postLeaveAppState.error.toString());

      notifyListeners();
      return false;
    } catch (e) {
      postLeaveAppState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(postLeaveAppState.error.toString());

      notifyListeners();
      return false;
    } finally {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  Future<bool> postLateInEarlyOut({
    required BuildContext context,
    required Map<String, dynamic> applicationData,
  }) async {
    context.loaderOverlay.show();
    postLateInAppState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.post(
        path: ApiUrl.lateInEarlyOut,
        data: applicationData,
      );

      if (response.statusCode == 201) {
        fetchLateInAppList();
        CustomSnackbar.success("Application created successfully!");
        notifyListeners();
        return true; // API succeeded
      } else {
        postLateInAppState = const ApiState.error(
          "Failed to create application",
        );
        CustomSnackbar.error(postLateInAppState.error.toString());

        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      postLateInAppState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(postLateInAppState.error.toString());

      notifyListeners();
      return false;
    } catch (e) {
      postLeaveAppState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(postLateInAppState.error.toString());

      notifyListeners();
      return false;
    } finally {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  Future<bool> postOfficialVisit({
    required BuildContext context,
    required Map<String, dynamic> applicationData,
  }) async {
    context.loaderOverlay.show();

    postOfficialAppState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.post(
        path: ApiUrl.createOfficialVisitApplication,
        data: applicationData,
      );

      if (response.statusCode == 201) {
        fetchOfficialAppList();
        CustomSnackbar.success("Application created successfully!");
        notifyListeners();
        return true; // API succeeded
      } else {
        postOfficialAppState = const ApiState.error(
          "Failed to create aplication",
        );
        CustomSnackbar.error(postOfficialAppState.error.toString());

        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      postOfficialAppState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(postOfficialAppState.error.toString());

      notifyListeners();
      return false;
    } catch (e) {
      postOfficialAppState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(postOfficialAppState.error.toString());

      notifyListeners();
      return false;
    } finally {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  Future<void> fetchOfficialVisitData() async {
    fetchOfficialState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.getOfficialVisitDropDown);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => OfficialVisitModel.fromJson(item))
            .toList();
        fetchOfficialState = ApiState.success(modelList);
        notifyListeners();
      } else {
        fetchOfficialState = const ApiState.error(
          "Failed to fetch official type data",
        );
        CustomSnackbar.error(fetchOfficialState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchOfficialState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchOfficialState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchOfficialState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchOfficialState.error.toString());
      notifyListeners();
    }
  }

  Future<void> fetchApproveData() async {
    fetchApproveState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.getApprover);

      if (response.statusCode == 200) {
        final model = ApproveRecommendModel.fromJson(response.data);
        fetchApproveState = ApiState.success(model);
        notifyListeners();
      } else {
        fetchApproveState = const ApiState.error(
          "Failed to fetch approve type data",
        );
        CustomSnackbar.error(fetchApproveState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchApproveState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchApproveState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchApproveState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchApproveState.error.toString());
      notifyListeners();
    }
  }

  Future<void> fetchLeaveTypeData() async {
    fetchLeaveTypeState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.getLeavesDropDown);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final modelList = data
            .map((item) => LeaveTypeModel.fromJson(item))
            .toList();
        fetchLeaveTypeState = ApiState.success(modelList);
        notifyListeners();
      } else {
        fetchLeaveTypeState = const ApiState.error(
          "Failed to fetch leave type data",
        );
        CustomSnackbar.error(fetchLeaveTypeState.error.toString());
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchLeaveTypeState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(fetchLeaveTypeState.error.toString());
      notifyListeners();
    } catch (e) {
      fetchLeaveTypeState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(fetchLeaveTypeState.error.toString());
      notifyListeners();
    }
  }
}
