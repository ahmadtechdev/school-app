// exams_model.dart
class ExamListResponse {
  final bool success;
  final Student student;
  final List<Exam> exams;

  ExamListResponse({
    required this.success,
    required this.student,
    required this.exams,
  });

  factory ExamListResponse.fromJson(Map<String, dynamic> json) {
    return ExamListResponse(
      success: json['success'] ?? false,
      student: Student.fromJson(json['student']),
      exams: (json['exams'] as List)
          .map((exam) => Exam.fromJson(exam))
          .toList(),
    );
  }
}

class Exam {
  final int id;
  final String name;
  final String date;
  final int totalMarks;
  final int obtainedMarks;
  final double percentage;

  Exam({
    required this.id,
    required this.name,
    required this.date,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      totalMarks: json['total_marks'] ?? 0,
      obtainedMarks: json['obtained_marks'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }
}

class ExamDetailsResponse {
  final bool success;
  final Exam exam;
  final Student student;
  final List<SubjectResult> resultCard;
  final int totalMarks;
  final int totalObtainedMarks;
  final double totalPercentage;

  ExamDetailsResponse({
    required this.success,
    required this.exam,
    required this.student,
    required this.resultCard,
    required this.totalMarks,
    required this.totalObtainedMarks,
    required this.totalPercentage,
  });

  factory ExamDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ExamDetailsResponse(
      success: json['success'] ?? false,
      exam: Exam.fromJson(json['exam']),
      student: Student.fromJson(json['student']),
      resultCard: (json['result_card'] as List)
          .map((subject) => SubjectResult.fromJson(subject))
          .toList(),
      totalMarks: json['total_marks'] ?? 0,
      totalObtainedMarks: json['total_obtained_marks'] ?? 0,
      totalPercentage: (json['total_percentage'] ?? 0.0).toDouble(),
    );
  }
}

class SubjectResult {
  final String subject;
  final String totalMarks;
  final String obtainedMarks;
  final String percentage;

  SubjectResult({
    required this.subject,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) {
    return SubjectResult(
      subject: json['subject'] ?? '',
      totalMarks: json['total_marks']?.toString() ?? '0',
      obtainedMarks: json['obtained_marks']?.toString() ?? '0',
      percentage: json['percentage']?.toString() ?? '0',
    );
  }
}

class Student {
  final int id;
  final String name;
  final String image;
  final String? className;
  final String? rollNo;
  final String? contactNo;
  final String? dateOfBirth;
  final String? fatherName;
  final String? motherName;

  Student({
    required this.id,
    required this.name,
    required this.image,
    this.className,
    this.rollNo,
    this.contactNo,
    this.dateOfBirth,
    this.fatherName,
    this.motherName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      className: json['class'] ?? json['className'],
      rollNo: json['roll_no'] ?? json['rollNo'],
      contactNo: json['contact_no'] ?? json['contactNo'],
      dateOfBirth: json['date_of_birth'] ?? json['dateOfBirth'],
      fatherName: json['father_name'] ?? json['fatherName'],
      motherName: json['mother_name'] ?? json['motherName'],
    );
  }
}