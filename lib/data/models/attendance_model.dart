// lib/data/models/attendance_model.dart
class AttendanceResponse {
  final bool success;
  final List<AttendanceRecord> attendance;
  final int totalPresents;
  final String todayStatus;

  AttendanceResponse({
    required this.success,
    required this.attendance,
    required this.totalPresents,
    required this.todayStatus,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] ?? false,
      attendance: (json['attendance'] as List)
          .map((item) => AttendanceRecord.fromJson(item))
          .toList(),
      totalPresents: json['total_presents'] ?? 0,
      todayStatus: json['todat_status'] ?? 'Not Taken',
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'Not Taken',
    );
  }
}