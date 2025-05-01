import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final AuthController _authController = Get.put(AuthController());
  late AnimationController _animationController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Animation
                _buildLottieAnimation()
                    .animate()
                    .fadeIn(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                )
                    .scale(
                  duration: const Duration(milliseconds: 800),
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
                    .animate()
                    .fadeIn(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                )
                    .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuad,
                ),

                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'Login to continue your journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 500),
                )
                    .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuad,
                ),

                const SizedBox(height: 30),

                // Form
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Lottie.asset(
        AppConstants.loginAnimation,
        controller: _animationController,
        height: 200,
        width: 200,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          // Check if widget is still mounted before using the controller
          if (!_isDisposed) {
            _animationController.duration = composition.duration;
            _animationController.forward();
          }
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Obx(() {
      final isLoading = _authController.loginState.value.isLoading;

      return Column(
        children: [
          // Phone field
          CustomTextField(
            label: 'Phone Number',
            hintText: 'Enter your phone number',
            controller: _authController.phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_android_rounded,
            errorText: _authController.phoneError.value,
          )
              .animate()
              .fadeIn(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
          )
              .slideX(
            begin: -0.1,
            end: 0,
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          ),

          const SizedBox(height: 16),

          // Password field
          CustomTextField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: _authController.passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            prefixIcon: Icons.lock_outline_rounded,
            errorText: _authController.passwordError.value,
          )
              .animate()
              .fadeIn(
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 500),
          )
              .slideX(
            begin: 0.1,
            end: 0,
            delay: const Duration(milliseconds: 600),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          ),

          const SizedBox(height: 30),

          // Login button
          CustomButton(
            text: isLoading ? 'Logging in...' : 'Login →',
            onPressed: () {
              // Only call login if not disposed
              if (!_isDisposed) {
                _authController.login();
              }
            },
            isLoading: isLoading,
            height: 56,
          )
              .animate()
              .fadeIn(
            delay: const Duration(milliseconds: 800),
            duration: const Duration(milliseconds: 500),
          )
              .slideY(
            begin: 0.2,
            end: 0,
            delay: const Duration(milliseconds: 800),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          ),

          const SizedBox(height: 40),
        ],
      );
    });
  }
}