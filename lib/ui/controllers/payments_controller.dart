// payment_controller.dart
import 'package:get/get.dart';

import '../../data/models/api_response.dart';
import '../../data/models/payments_model.dart';
import '../../data/repositories/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repository = PaymentRepository();

  var isLoading = true.obs;
  var paymentData = Rx<PaymentModel?>(null);
  var errorMessage = ''.obs;

  Future<void> fetchPayments(int studentId) async {
    try {
      isLoading(true);
      errorMessage('');

      final ApiResponse<PaymentModel> response =
      await _repository.getPayments(studentId);

      if (response.isSuccess) {
        paymentData(response.data);
      } else {
        errorMessage(response.message);
      }
    } catch (e) {
      errorMessage('Failed to fetch payment data');
    } finally {
      isLoading(false);
    }
  }
}