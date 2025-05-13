// lib/data/repositories/attendance_repository.dart
import '../../core/services/api_service.dart';
import '../models/api_response.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final ApiService _apiService;

  AttendanceRepository({required ApiService apiService}) : _apiService = apiService;

  Future<ApiResponse<AttendanceResponse>> getAttendance(
      int studentId, {
        int? month,
        int? year,
      }) async {
    return await _apiService.getAttendance(
      studentId,
      month: month,
      year: year,
    );
  }
}