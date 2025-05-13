// lib/controllers/attendance_controller.dart
import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _repository;

  AttendanceController({required AttendanceRepository repository})
      : _repository = repository;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var attendanceData = <AttendanceRecord>[].obs;
  var totalPresents = 0.obs;
  var todayStatus = ''.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendance();
  }

  Future<void> loadAttendance({int? month, int? year}) async {
    try {
      isLoading(true);
      errorMessage('');

      if (month != null) selectedMonth(month);
      if (year != null) selectedYear(year);

      final response = await _repository.getAttendance(
        1, // Replace with actual student ID
        month: selectedMonth.value,
        year: selectedYear.value,
      );

      if (response.success && response.data != null) {
        attendanceData(response.data!.attendance);
        totalPresents(response.data!.totalPresents);
        todayStatus(response.data!.todayStatus);
      } else {
        errorMessage(response.message);
      }
    } catch (e) {
      errorMessage('Failed to load attendance data. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  void changeMonth(int month, int year) {
    selectedMonth(month);
    selectedYear(year);
    loadAttendance(month: month, year: year);
  }
}