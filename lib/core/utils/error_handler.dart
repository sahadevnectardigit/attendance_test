import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleError(DioException e) {
    // 1. Timeout cases
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Connection timeout. Please try again.";
    }

    // 2. Request cancelled
    if (e.type == DioExceptionType.cancel) {
      return "Request was cancelled.";
    }

    // 3. No internet / socket issues
    if (e.type == DioExceptionType.connectionError) {
      return "No internet connection.";
    }

    // 4. Has server response
    if (e.response != null) {
      final statusCode = e.response?.statusCode;

      // Try to read message from API response body
      final dynamic data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      // final dynamic data = e.response?.data;
      if (data is Map && data['error'] != null) {
        return data['error'].toString();
      }

      switch (statusCode) {
        case 400:
          return "Bad request";
        case 401:
          return "Unauthorized request";
        case 403:
          return "Forbidden request";
        case 404:
          return "Resource not found";
        case 409:
          return "Conflict error";
        case 422:
          return "Validation failed";
        case 500:
        case 502:
        case 503:
          return "Server error. Please try again later.";
        default:
          return "Unexpected error (${statusCode ?? "unknown"})";
      }
    }

    // 5. Unknown error
    return e.message ?? "Something went wrong. Please try again.";
  }
}

// class ApiErrorHandler {
//   static String handleError(DioException e) {
//     if (e.response != null) {
//       switch (e.response?.statusCode) {
//         case 400:
//           return "Bad request";
//         case 401:
//           return "Unauthorized request";
//         case 403:
//           return "Forbidden request";
//         case 404:
//           return "Resource not found";
//         case 500:
//           return "Server error, try again later";
//         default:
//           return "Unexpected error: ${e.response?.statusCode}";
//       }
//     } else {
//       return "No internet connection"; //${e.message}
//     }
//   }
// }
