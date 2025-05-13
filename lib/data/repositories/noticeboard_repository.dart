// noticeboard_repository.dart
import '../../core/services/api_service.dart';
import '../models/api_response.dart';
import '../models/noticeboard_model.dart';

class NoticeBoardRepository {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<NoticeBoardResponse>> getNoticeBoard(int studentId) async {
    return await _apiService.getNoticeBoard(studentId);
  }
}