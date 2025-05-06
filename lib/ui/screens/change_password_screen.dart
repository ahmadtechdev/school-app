import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../controllers/password_controller.dart';


class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final PasswordController controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              // Background design with curved top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              // Main content
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Top animation
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 150,
                      child: Lottie.asset(
                        'assets/animations/password_animation.json',
                        fit: BoxFit.contain,
                        animate: true,
                        repeat: true,
                      ),
                    ),
                    // Card with form
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Center(
                                child: Text(
                                  'Update Your Password',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'Please enter your current password and a new password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Current Password
                              _buildPasswordField(
                                label: 'Current Password',
                                hintText: 'Enter your current password',
                                controller: controller.currentPasswordController,
                                isVisible: controller.isCurrentPasswordVisible,
                                toggleVisibility: controller.toggleCurrentPasswordVisibility,
                                validator: controller.validatePassword,
                              ),
                              const SizedBox(height: 20),

                              // New Password
                              _buildPasswordField(
                                label: 'New Password',
                                hintText: 'Enter your new password',
                                controller: controller.newPasswordController,
                                isVisible: controller.isNewPasswordVisible,
                                toggleVisibility: controller.toggleNewPasswordVisibility,
                                validator: controller.validatePassword,
                              ),
                              const SizedBox(height: 20),

                              // Confirm Password
                              _buildPasswordField(
                                label: 'Confirm New Password',
                                hintText: 'Confirm your new password',
                                controller: controller.confirmPasswordController,
                                isVisible: controller.isConfirmPasswordVisible,
                                toggleVisibility: controller.toggleConfirmPasswordVisibility,
                                validator: controller.validateConfirmPassword,
                              ),

                              // Error message
                              if (controller.errorMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 30),

                              // Submit Button
                              _buildChangePasswordButton(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Password strength tips

                  ],
                ),
              ),

              // Loading overlay
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required RxBool isVisible,
    required Function() toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return TextFormField(
            controller: controller,
            obscureText: !isVisible.value,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible.value ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.primary,
                ),
                onPressed: toggleVisibility,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return Obx(() {
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.changePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
              : Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.info,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}