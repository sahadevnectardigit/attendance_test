import 'dart:io';

import 'package:attendance/core/services/custom_snackbar.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/utils/error_handler.dart';
import 'package:attendance/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../models/api_state.dart';

class ProfileProvider extends ChangeNotifier {
  static final MainApiClient _client = MainApiClient();

  ApiState<void> changePasswordState = const ApiState.initial();
  ApiState<ProfileModel> fetchProfileState = const ApiState.initial();
  ApiState<void> updateProfileState = const ApiState.initial();

  Future<bool> updateProfile({File? imageFile}) async {
    updateProfileState = const ApiState.loading();
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile?.path ?? "",
          filename: imageFile?.path.split('/').last,
        ),
      });

      final response = await _client.post(
        path: ApiUrl.updateProfileImage,
        data: formData,
      );
      if (response.statusCode == 200) {
        CustomSnackbar.success(" Profile Updated successfully");
        updateProfileState = const ApiState.success(null);
        fetchProfileData();
        notifyListeners();
        return true; // API succeeded
      } else {
        updateProfileState = const ApiState.error(
          "Failed to change profile image",
        );
        CustomSnackbar.error(updateProfileState.error.toString());

        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      updateProfileState = ApiState.error(ApiErrorHandler.handleError(e));
      CustomSnackbar.error(updateProfileState.error.toString());

      notifyListeners();
      return false;
    } catch (e) {
      updateProfileState = ApiState.error("Unexpected error: $e");
      CustomSnackbar.error(updateProfileState.error.toString());

      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({required String password}) async {
    changePasswordState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.post(
        path: ApiUrl.changePassword,
        data: {"new_password": password},
      );

      if (response.statusCode == 200) {
        changePasswordState = const ApiState.success(null);
        notifyListeners();
        return true; // API succeeded
      } else {
        changePasswordState = const ApiState.error("Failed to change password");
        notifyListeners();
        return false; // API failed
      }
    } on DioException catch (e) {
      changePasswordState = ApiState.error(ApiErrorHandler.handleError(e));
      notifyListeners();
      return false;
    } catch (e) {
      changePasswordState = ApiState.error("Unexpected error: $e");
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfileData() async {
    fetchProfileState = const ApiState.loading();
    notifyListeners();

    try {
      final response = await _client.get(path: ApiUrl.profile);

      if (response.statusCode == 200) {
        final model = ProfileModel.fromJson(response.data);
        fetchProfileState = ApiState.success(model);
        notifyListeners();
      } else {
        fetchProfileState = const ApiState.error(
          "Failed to fetch profile data",
        );
        notifyListeners();
      }
    } on DioException catch (e) {
      fetchProfileState = ApiState.error(ApiErrorHandler.handleError(e));
      notifyListeners();
    } catch (e) {
      fetchProfileState = ApiState.error("Unexpected error: $e");
      notifyListeners();
    }
  }

}
