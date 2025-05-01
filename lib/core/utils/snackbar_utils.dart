import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../constants/colors.dart';

class SnackbarUtils {
  // Success snackbar
  static void showSuccess(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      borderRadius: AppConstants.defaultBorderRadius,
      duration: AppConstants.snackBarDuration,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Error snackbar
  static void showError(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      borderRadius: AppConstants.defaultBorderRadius,
      duration: AppConstants.snackBarDuration,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Info snackbar
  static void showInfo(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      borderRadius: AppConstants.defaultBorderRadius,
      duration: AppConstants.snackBarDuration,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Warning snackbar
  static void showWarning(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      borderRadius: AppConstants.defaultBorderRadius,
      duration: AppConstants.snackBarDuration,
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.white),
      boxShadows: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}