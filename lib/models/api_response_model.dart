class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  ApiResponse.success(this.data) : isSuccess = true, message = null;

  ApiResponse.failure(this.message) : isSuccess = false, data = null;
}
