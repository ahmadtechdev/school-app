import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/ui/screens/dashbaord_screen.dart';
import 'package:school_parent_app/ui/screens/login_screen.dart';
import 'package:school_parent_app/ui/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static String getInitialRoute() {
    return splash;
  }

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: splash,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: login,
        page: () => const LoginScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: dashboard,
        page: () => const DashboardScreen(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}