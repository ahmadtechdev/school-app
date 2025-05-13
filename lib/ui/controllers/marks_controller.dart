// marks_controller.dart
import 'package:get/get.dart';

import '../../data/models/api_response.dart';
import '../../data/models/exams_model.dart';
import '../../data/repositories/exam_repository.dart';

class MarksController extends GetxController {
  final int studentId;
  final ExamRepository _repository = ExamRepository();

  var isLoading = true.obs;
  var error = ''.obs;
  var student = Rxn<Student>();
  var exams = <Exam>[].obs;

  MarksController({required this.studentId});

  @override
  void onInit() {
    super.onInit();
    fetchExamList();
  }

  Future<void> fetchExamList() async {
    try {
      isLoading(true);
      error('');

      final ApiResponse<ExamListResponse> response =
      await _repository.getExamList(studentId);

      if (response.isSuccess && response.data != null) {
        student.value = response.data!.student;
        exams.assignAll(response.data!.exams);
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = 'Failed to load exams. Please try again.';
    } finally {
      isLoading(false);
    }
  }
}