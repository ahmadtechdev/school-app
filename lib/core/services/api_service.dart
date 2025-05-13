import 'dart:io';
import 'package:dio/dio.dart';

import '../../data/models/api_response.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/dashboard.dart';
import '../../data/models/exams_model.dart';
import '../../data/models/noticeboard_model.dart';
import '../../data/models/password_change_model.dart';
import '../../data/models/payments_model.dart';
import '../constants/app_constants.dart';


class ApiService {
  late Dio _dio;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Dashboard data fetch method
  // In api_service.dart
  Future<ApiResponse<DashboardModel>> getDashboardData() async {
    try {
      // Ensure we have the auth token
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<DashboardModel>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final response = await _dio.get(
        AppConstants.dashboardEndpoint,
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      return _processResponse<DashboardModel>(
        response,
            (data) => DashboardModel.fromJson(data),
      );
    } catch (e) {
      return _handleError<DashboardModel>(e);
    }
  }
  // Generic GET request
  Future<ApiResponse<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // In api_service.dart
  Future<ApiResponse<T>> logout<T>() async {
    try {
      final response = await _dio.post(
        AppConstants.logoutEndpoint,
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );
      return _processResponse<T>(response, null);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Add this function to your existing ApiService class

  Future<ApiResponse> updatePassword(PasswordChangeModel passwordData) async {
    try {
      // Ensure we have the auth token
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final response = await _dio.put(
        '/update-password',
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
            'Content-Type': 'application/json',
          },
        ),
        data: passwordData.toJson(),
      );

      return _processResponse(response, null);
    } catch (e) {
      return _handleError(e);
    }
  }

  // In api_service.dart
  Future<ApiResponse<PaymentModel>> getPayments(int studentId) async {
    try {
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<PaymentModel>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final response = await _dio.get(
        '${AppConstants.paymentsEndpoint}/$studentId',
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      return _processResponse<PaymentModel>(
        response,
            (data) => PaymentModel.fromJson(data),
      );
    } catch (e) {
      return _handleError<PaymentModel>(e);
    }
  }


  // In api_service.dart
  Future<ApiResponse<NoticeBoardResponse>> getNoticeBoard(int studentId) async {
    try {
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<NoticeBoardResponse>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final response = await _dio.get(
        '${AppConstants.noticeboardEndpoint}/$studentId',
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      return _processResponse<NoticeBoardResponse>(
        response,
            (data) => NoticeBoardResponse.fromJson(data),
      );
    } catch (e) {
      return _handleError<NoticeBoardResponse>(e);
    }
  }

  // In api_service.dart
  Future<ApiResponse<ExamListResponse>> getExamList(int studentId) async {
    try {
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<ExamListResponse>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final response = await _dio.get(
        '${AppConstants.examListEndpoint}/$studentId',
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      return _processResponse<ExamListResponse>(
        response,
            (data) => ExamListResponse.fromJson(data),
      );
    } catch (e) {
      return _handleError<ExamListResponse>(e);
    }
  }

  Future<ApiResponse<ExamDetailsResponse>> getExamDetails(int examId, int studentId) async {
    print("Check 1");
    try {
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<ExamDetailsResponse>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }
    print("Check 12");

      final response = await _dio.get(
        '${AppConstants.examDetailsEndpoint}/$examId/$studentId',
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      print("Check 123");
      print(response.data);

      return _processResponse<ExamDetailsResponse>(
        response,
            (data) => ExamDetailsResponse.fromJson(data),
      );
    } catch (e) {
      return _handleError<ExamDetailsResponse>(e);
    }
  }

  Future<ApiResponse<AttendanceResponse>> getAttendance(
      int studentId, {
        int? month,
        int? year,
      }) async {
    try {
      final token = _dio.options.headers['Authorization'];
      if (token == null || token.isEmpty) {
        return ApiResponse<AttendanceResponse>(
          success: false,
          data: null,
          message: 'Authentication token missing',
        );
      }

      final queryParameters = <String, dynamic>{};
      if (month != null) queryParameters['month'] = month;
      if (year != null) queryParameters['year'] = year;

      final response = await _dio.get(
        '${AppConstants.attendanceEndpoint}/$studentId',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        options: Options(
          headers: {
            'Authorization': _dio.options.headers['Authorization'],
          },
        ),
      );

      return _processResponse<AttendanceResponse>(
        response,
            (data) => AttendanceResponse.fromJson(data),
      );
    } catch (e) {
      return _handleError<AttendanceResponse>(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic)? fromJson,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Process successful response
  ApiResponse<T> _processResponse<T>(
      Response response,
      T Function(dynamic)? fromJson,
      ) {
    final data = response.data;
    final bool success = data['success'] ?? false;

    if (success) {
      final result = fromJson != null ? fromJson(data) : data;
      return ApiResponse<T>(
        success: true,
        data: result,
        message: data['message'] ?? 'Success',
      );
    } else {
      return ApiResponse<T>(
        success: false,
        data: null,
        message: data['error'] ?? 'Unknown error occurred',
      );
    }
  }

  // Handle errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    String errorMessage = AppConstants.genericErrorMessage;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timeout. Please try again.';
          break;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;

          if (responseData != null && responseData is Map) {
            errorMessage = responseData['message'] ?? AppConstants.genericErrorMessage;
          } else if (statusCode == 401) {
            errorMessage = 'Unauthorized access. Please login again.';
          } else if (statusCode == 404) {
            errorMessage = 'Resource not found.';
          } else if (statusCode == 500) {
            errorMessage = 'Server error. Please try again later.';
          }
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = AppConstants.networkErrorMessage;
          break;
        default:
          errorMessage = AppConstants.genericErrorMessage;
          break;
      }
    } else if (error is SocketException) {
      errorMessage = AppConstants.networkErrorMessage;
    }

    return ApiResponse<T>(
      success: false,
      data: null,
      message: errorMessage,
    );
  }
}