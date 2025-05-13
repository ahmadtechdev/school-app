import 'package:get/get.dart';

import '../../data/models/dashboard.dart';
import '../../data/models/study_material_model.dart';
import '../../data/repositories/study_material_repository.dart';

class StudyMaterialController extends GetxController {
  final StudyMaterialRepository _repository = StudyMaterialRepository();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<StudyMaterial> studyMaterials = <StudyMaterial>[].obs;
  Student? student;

  Future<void> loadStudyMaterials(int studentId) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _repository.getStudyMaterials(studentId);
      student = response.student;
      studyMaterials.assignAll(response.studyMaterials);
    } catch (e) {
      errorMessage(e.toString());
      studyMaterials.clear();
    } finally {
      isLoading(false);
    }
  }
}