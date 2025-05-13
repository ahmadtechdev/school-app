class AppConstants {
  // API endpoints
  static const String baseUrl = 'https://demo.girdonawah.com/api';
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String dashboardEndpoint = '/dashboard';
  static const String paymentsEndpoint = '/get-payments';
  static const String noticeboardEndpoint = '/get-noticeboard';
  static const String examListEndpoint = '/get-exam-list';
  static const String examDetailsEndpoint = '/get-result-card';
  static const String attendanceEndpoint = '/get-attendance';
  static const String studyMaterialEndpoint = '/get-studymaterial';

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Animation assets
  static const String splashAnimation = 'assets/animations/login_animation.json';
  static const String loginAnimation = 'assets/animations/login_animation.json';

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String authErrorMessage = 'Authentication failed. Please check your credentials.';
}