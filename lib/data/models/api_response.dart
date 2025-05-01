class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
  });

  // Helper methods
  bool get isSuccess => success;
  bool get isError => !success;
}