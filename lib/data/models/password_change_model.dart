class PasswordChangeModel {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  PasswordChangeModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }

  // For validation
  bool isValid() {
    return currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        newPassword == confirmPassword;
  }
}