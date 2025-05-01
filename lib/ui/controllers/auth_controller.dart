import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/loading_state.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../data/models/login_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes.dart';


class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Make controllers final and initialize them immediately
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Form validation
  final phoneError = RxString('');
  final passwordError = RxString('');

  // Loading state
  final Rx<LoadingState<LoginResponse>> loginState =
  Rx<LoadingState<LoginResponse>>(LoadingState.initial());

  // Track if login is in progress
  final _isLoginInProgress = false.obs;
  bool get isLoginInProgress => _isLoginInProgress.value;

  @override
  void onClose() {
    // Only dispose if the controller is still mounted
    if (!phoneController.hasListeners) {
      phoneController.dispose();
    }
    if (!passwordController.hasListeners) {
      passwordController.dispose();
    }
    super.onClose();
  }

  void clearErrors() {
    phoneError.value = '';
    passwordError.value = '';
  }

  bool validateForm() {
    clearErrors();
    bool isValid = true;

    if (phoneController.text.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phoneController.text.length < 5) {
      phoneError.value = 'Enter a valid phone number';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 4) {
      passwordError.value = 'Password must be at least 4 characters';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (isLoginInProgress) return;
    if (!validateForm()) return;

    _isLoginInProgress.value = true;
    loginState.value = LoadingState.loading();

    try {
      final request = LoginRequest(
        phone: phoneController.text,
        password: passwordController.text,
      );

      final response = await _authRepository.login(request);

      if (response.success) {
        loginState.value = LoadingState.success(
          data: response.data,
          message: response.message,
        );
        SnackbarUtils.showSuccess('Login successful');
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        loginState.value = LoadingState.error(
          message: response.message,
        );
        SnackbarUtils.showError(response.message);
      }
    } catch (e) {
      loginState.value = LoadingState.error(
        message: 'Login failed. Please try again.',
      );
      SnackbarUtils.showError('Login failed. Please try again.');
    } finally {
      _isLoginInProgress.value = false;
    }
  }

  bool isLoggedIn() {
    return _authRepository.isLoggedIn();
  }

  // In auth_controller.dart
  Future<void> logout() async {
    try {
      final response = await _authRepository.logout();
      if (response.success) {
        SnackbarUtils.showSuccess('Logged out successfully');
      } else {
        SnackbarUtils.showError(response.message);
      }
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      SnackbarUtils.showError('Error during logout');
      Get.offAllNamed(AppRoutes.login);
    }
  }
}