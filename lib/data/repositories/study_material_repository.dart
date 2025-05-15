import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/api_service.dart';
import '../models/study_material_model.dart';

class StudyMaterialRepository {
  final ApiService _apiService = Get.put(ApiService());

  Future<StudyMaterialResponse> getStudyMaterials(int studentId) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.studyMaterialEndpoint}/$studentId',
        fromJson: (data) => StudyMaterialResponse.fromJson(data),
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      return response.data as StudyMaterialResponse;
    } catch (e) {
      throw Exception('Failed to load study materials: ${e.toString()}');
    }
  }
}