// payment_repository.dart
import '../../core/services/api_service.dart';
import '../models/api_response.dart';
import '../models/payments_model.dart';


class PaymentRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<PaymentModel>> getPayments(int studentId) async {
    return await _apiService.getPayments(studentId);
  }
}