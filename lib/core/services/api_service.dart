import 'dart:io';
import 'package:dio/dio.dart';

import '../../data/models/api_response.dart';
import '../../data/models/dashboard.dart';
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
  Future<ApiResponse<DashboardModel>> getDashboardData() async {
    try {
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
            errorMessage = responseData['error'] ?? AppConstants.genericErrorMessage;
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