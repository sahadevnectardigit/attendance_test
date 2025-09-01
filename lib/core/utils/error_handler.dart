import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return "Invalid email or password";
        case 401:
          return "Unauthorized request";
        case 403:
          return "Forbidden request";
        case 404:
          return "Resource not found";
        case 500:
          return "Server error, try again later";
        default:
          return "Unexpected error: ${e.response?.statusCode}";
      }
    } else {
      return "No internet connection"; //${e.message}
    }
  }
}
