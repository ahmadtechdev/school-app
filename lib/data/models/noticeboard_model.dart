// noticeboard_model.dart
class NoticeBoardResponse {
  final bool success;
  final Student student;
  final List<Notice> notices;

  NoticeBoardResponse({
    required this.success,
    required this.student,
    required this.notices,
  });

  factory NoticeBoardResponse.fromJson(Map<String, dynamic> json) {
    return NoticeBoardResponse(
      success: json['success'] ?? false,
      student: Student.fromJson(json['student']),
      notices: (json['notices'] as List)
          .map((notice) => Notice.fromJson(notice))
          .toList(),
    );
  }
}

class Student {
  final int id;
  final String name;
  final String image;

  Student({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Notice {
  final int id;
  final String message;
  final String? file;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notice({
    required this.id,
    required this.message,
    this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Helper getters for UI compatibility
  String get title => 'Notice #$id';
  String get description => message;
  DateTime get date => createdAt;
  bool get hasAttachment => file != null;
  String? get attachmentUrl => file;
  String? get attachmentName => file?.split('/').last;
}