import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../../core/services/storage_service.dart';
import '../../routes.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _dnaAnimationController;
  late AnimationController _fadeController;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _dnaAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _dnaAnimationController.forward();

    // Delay the text fade-in
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });

    // Initialize storage and then navigate
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Ensure storage is initialized before checking login status
    await _storageService.init();

    // Add a small delay to make sure the storage is ready
    await Future.delayed(AppConstants.splashDuration);

    final AuthController authController = Get.put(AuthController());

    // This will now also set the token in ApiService if logged in
    if (authController.isLoggedIn()) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _dnaAnimationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashBackground,
              AppColors.primaryLight.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DNA Animation
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: _buildDnaAnimation(),
                ),
                const SizedBox(height: 40),

                // App Name
                FadeTransition(
                  opacity: _fadeController,
                  child: const Text(
                    'Parent Portal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  )
                      .animate()
                      .slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutQuad,
                    duration: const Duration(milliseconds: 800),
                  ),
                ),
                const SizedBox(height: 16),

                // App Tagline
                FadeTransition(
                  opacity: _fadeController,
                  child: const Text(
                    'Smart Parenting Starts Here',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate()
                      .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: const Duration(milliseconds: 100),
                    curve: Curves.easeOutQuad,
                    duration: const Duration(milliseconds: 800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDnaAnimation() {
    return Lottie.asset(
      AppConstants.splashAnimation,
      controller: _dnaAnimationController,
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      animate: true,
      onLoaded: (composition) {
        _dnaAnimationController.duration = composition.duration;
        _dnaAnimationController
          ..forward()
          ..repeat();
      },
    );
  }
}