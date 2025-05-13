// exam_details_controller.dart
import 'package:get/get.dart';

import '../../data/models/api_response.dart';
import '../../data/models/exams_model.dart';
import '../../data/repositories/exam_repository.dart';

class ExamDetailsController extends GetxController {
  final int examId;
  final ExamRepository _repository = ExamRepository();

  var isLoading = true.obs;
  var error = ''.obs;
  var examDetails = Rxn<ExamDetailsResponse>();

  ExamDetailsController({required this.examId});

  @override
  void onInit() {
    super.onInit();
    fetchExamDetails();
  }

  Future<void> fetchExamDetails() async {
    try {
      isLoading(true);
      error('');

      // Get studentId from the previous screen
      final int studentId = Get.arguments['studentId'] ?? 0;

      final ApiResponse<ExamDetailsResponse> response =
      await _repository.getExamDetails(examId, studentId);

      if (response.isSuccess && response.data != null) {
        examDetails.value = response.data!;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = 'Failed to load exam details. Please try again.';
    } finally {
      isLoading(false);
    }
  }
}