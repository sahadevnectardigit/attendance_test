class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  ApiResponse.success(this.data) : isSuccess = true, message = null;

  ApiResponse.failure(this.message) : isSuccess = false, data = null;
}

class ApiState<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  const ApiState._({this.data, this.error, this.isLoading = false});

  /// Initial state (nothing loaded yet)
  const ApiState.initial() : this._();

  /// Loading state
  const ApiState.loading() : this._(isLoading: true);

  /// Success state with data
  const ApiState.success(T data) : this._(data: data);

  /// Error state with message
  const ApiState.error(String error) : this._(error: error);

  /// Helpers for UI
  bool get hasData => data != null;
  bool get hasError => error != null && error!.isNotEmpty;
}
