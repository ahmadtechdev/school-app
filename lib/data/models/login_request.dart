class LoginRequest {
  final String phone;
  final String password;

  LoginRequest({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String? token;
  final Map<String, dynamic>? userData;
  final String? error;

  LoginResponse({
    required this.success,
    this.token,
    this.userData,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'],
      userData: json['user'],
      error: json['error'],
    );
  }
}