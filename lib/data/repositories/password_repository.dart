import '../../core/services/api_service.dart';
import '../models/api_response.dart';
import '../models/password_change_model.dart';


class PasswordRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> changePassword(PasswordChangeModel passwordData) async {
    return await _apiService.updatePassword(passwordData);
  }
}