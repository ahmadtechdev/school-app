// noticeboard_controller.dart
import 'package:get/get.dart';

import '../../data/models/api_response.dart';
import '../../data/models/noticeboard_model.dart';
import '../../data/repositories/noticeboard_repository.dart';

class NoticeBoardController extends GetxController {
  final String studentId;
  final NoticeBoardRepository _repository = NoticeBoardRepository();

  var isLoading = false.obs;
  var error = ''.obs;
  var student = Rxn<Student>();
  var notices = <Notice>[].obs;
  var filteredNotices = <Notice>[].obs;

  NoticeBoardController({required this.studentId});

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      isLoading.value = true;
      error.value = '';

      final ApiResponse<NoticeBoardResponse> response =
      await _repository.getNoticeBoard(int.parse(studentId));

      if (response.isSuccess && response.data != null) {
        student.value = response.data!.student;
        notices.value = response.data!.notices;
        filteredNotices.value = notices;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = 'Failed to load notices. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void searchNotices(String query) {
    if (query.isEmpty) {
      filteredNotices.value = notices;
      return;
    }

    filteredNotices.value = notices.where((notice) {
      return notice.title.toLowerCase().contains(query.toLowerCase()) ||
          notice.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}