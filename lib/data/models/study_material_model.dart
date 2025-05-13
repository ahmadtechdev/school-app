import 'dashboard.dart';

class StudyMaterialResponse {
  final bool success;
  final Student student;
  final List<StudyMaterial> studyMaterials;

  StudyMaterialResponse({
    required this.success,
    required this.student,
    required this.studyMaterials,
  });

  factory StudyMaterialResponse.fromJson(Map<String, dynamic> json) {
    return StudyMaterialResponse(
      success: json['success'] ?? false,
      student: Student.fromJson(json['student']),
      studyMaterials: List<StudyMaterial>.from(
        json['study_materials'].map((x) => StudyMaterial.fromJson(x)),
      ),
    );
  }
}

class StudyMaterial {
  final int id;
  final String title;
  final String file;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'],
      title: json['title'],
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get fileType {
    final ext = file.split('.').last.toLowerCase();
    if (ext == 'pdf') return 'PDF';
    if (ext == 'doc' || ext == 'docx') return 'DOCX';
    if (ext == 'xls' || ext == 'xlsx') return 'XLSX';
    if (ext == 'ppt' || ext == 'pptx') return 'PPTX';
    if (ext == 'zip' || ext == 'rar') return 'ZIP';
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') return 'IMAGE';
    if (ext == 'mp4' || ext == 'mov') return 'VIDEO';
    if (ext == 'mp3' || ext == 'wav') return 'AUDIO';
    return ext.toUpperCase();
  }

  String get fileSize {
    // This would normally come from the API or be calculated
    // For now, we'll return a placeholder
    return '1.5 MB';
  }
}