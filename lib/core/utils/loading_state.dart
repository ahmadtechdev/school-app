enum LoadingStatus {
  initial,
  loading,
  success,
  error,
}

class LoadingState<T> {
  final LoadingStatus status;
  final T? data;
  final String? message;
  final bool isLoading;

  LoadingState({
    required this.status,
    this.data,
    this.message,
  }) : isLoading = status == LoadingStatus.loading;

  // Factory constructors for different states
  factory LoadingState.initial() => LoadingState(status: LoadingStatus.initial);

  factory LoadingState.loading() => LoadingState(status: LoadingStatus.loading);

  factory LoadingState.success({T? data, String? message}) =>
      LoadingState(status: LoadingStatus.success, data: data, message: message);

  factory LoadingState.error({String? message}) =>
      LoadingState(status: LoadingStatus.error, message: message);

  // Helper methods to check state
  bool get isInitial => status == LoadingStatus.initial;
  bool get isSuccess => status == LoadingStatus.success;
  bool get isError => status == LoadingStatus.error;

  // Copy with method for easy state updates
  LoadingState<T> copyWith({
    LoadingStatus? status,
    T? data,
    String? message,
  }) {
    return LoadingState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }
}