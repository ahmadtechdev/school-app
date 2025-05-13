// exam_repository.dart
import '../../core/services/api_service.dart';
import '../models/api_response.dart';
import '../models/exams_model.dart';

class ExamRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<ExamListResponse>> getExamList(int studentId) async {
    return await _apiService.getExamList(studentId);
  }

  Future<ApiResponse<ExamDetailsResponse>> getExamDetails(int examId, int studentId) async {
    return await _apiService.getExamDetails(examId, studentId);
  }
}