import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../models/api_response.dart';
import '../models/login_request.dart';


class AuthRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Login user
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'phone': request.phone,
        'password': request.password,
      });

      // Make API call
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // Process the response
      if (response.success) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Save auth data if login was successful
        if (loginResponse.success && loginResponse.token != null) {
          await _storageService.saveAuthToken(loginResponse.token!);
          if (loginResponse.userData != null) {
            await _storageService.saveUserData(loginResponse.userData!);
          }
          await _storageService.setLoggedIn(true);

          // Debug print
          print('Login successful. Token saved: ${loginResponse.token}');
          print('isLoggedIn set to: ${_storageService.isLoggedIn()}');

          // Set auth token for future API calls
          _apiService.setAuthToken(loginResponse.token!);
        }

        return ApiResponse<LoginResponse>(
          success: loginResponse.success,
          data: loginResponse,
          message: loginResponse.success
              ? 'Login successful'
              : (loginResponse.error ?? 'Login failed'),
        );
      } else {
        return ApiResponse<LoginResponse>(
          success: false,
          data: LoginResponse(success: false, error: response.message),
          message: response.message,
        );
      }
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        data: LoginResponse(success: false, error: 'Login failed'),
        message: e.toString(),
      );
    }
  }

  // Check if user is logged in
  // In auth_repository.dart
  bool isLoggedIn() {
    final isLoggedIn = _storageService.isLoggedIn();
    final token = _storageService.getAuthToken();

    // Set the token in ApiService if logged in
    if (isLoggedIn && token != null && token.isNotEmpty) {
      _apiService.setAuthToken(token);
    }

    return isLoggedIn && token != null && token.isNotEmpty;
  }

  // Logout
  Future<ApiResponse<dynamic>> logout() async {
    try {
      // First call the API logout
      final response = await _apiService.logout();

      // Then clear local storage regardless of API response
      await _storageService.clearAll();

      return response;
    } catch (e) {
      // Still clear local storage even if API call fails
      await _storageService.clearAll();
      return ApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}