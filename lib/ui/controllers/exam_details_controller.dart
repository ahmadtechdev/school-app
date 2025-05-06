import 'package:get/get.dart';

// Model class for exam details
class ExamDetail {
  final String id;
  final String studentName;
  final String rollNumber;
  final String grade;
  final String dateOfBirth;
  final String fatherName;
  final String motherName;
  final int totalMarks;
  final int obtainedMarks;
  final double percentage;
  final bool isPassed;
  final String teacherComment;
  final List<SubjectMark> subjects;

  ExamDetail({
    required this.id,
    required this.studentName,
    required this.rollNumber,
    required this.grade,
    required this.dateOfBirth,
    required this.fatherName,
    required this.motherName,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
    required this.isPassed,
    required this.teacherComment,
    required this.subjects,
  });

  // Factory method to create ExamDetail from JSON
  factory ExamDetail.fromJson(Map<String, dynamic> json) {
    // Parse subjects list
    List<SubjectMark> subjectsList = [];
    if (json['subjects'] != null) {
      subjectsList = List<SubjectMark>.from(
        json['subjects'].map((subject) => SubjectMark.fromJson(subject)),
      );
    }

    return ExamDetail(
      id: json['id'] ?? '',
      studentName: json['studentName'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      grade: json['grade'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      totalMarks: json['totalMarks'] ?? 0,
      obtainedMarks: json['obtainedMarks'] ?? 0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
      isPassed: json['isPassed'] ?? false,
      teacherComment: json['teacherComment'] ?? '',
      subjects: subjectsList,
    );
  }
}

// Model class for subject marks
class SubjectMark {
  final String name;
  final int totalMarks;
  final int obtainedMarks;
  final double percentage;

  SubjectMark({
    required this.name,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
  });

  // Factory method to create SubjectMark from JSON
  factory SubjectMark.fromJson(Map<String, dynamic> json) {
    return SubjectMark(
      name: json['name'] ?? '',
      totalMarks: json['totalMarks'] ?? 0,
      obtainedMarks: json['obtainedMarks'] ?? 0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
    );
  }
}

class ExamDetailsController extends GetxController {
  final String examId;

  // Observable variables
  var isLoading = true.obs;
  var error = ''.obs;
  Rx<ExamDetail?> examDetails = Rx<ExamDetail?>(null);

  ExamDetailsController({required this.examId});

  @override
  void onInit() {
    super.onInit();
    fetchExamDetails();
  }

  Future<void> fetchExamDetails() async {
    try {
      isLoading(true);
      error('');

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll populate with mock data
      // In a real app, you would make an API call here
      // Example: final response = await apiService.getExamDetails(examId);

      // Mock data for demonstration
      final Map<String, dynamic> mockData = {
        'id': examId,
        'studentName': 'John Smith',
        'rollNumber': 'STD-1234',
        'grade': 'Grade 9-A',
        'dateOfBirth': '12-05-2009',
        'fatherName': 'Michael Smith',
        'motherName': 'Sarah Smith',
        'totalMarks': 500,
        'obtainedMarks': 435,
        'percentage': 87.0,
        'isPassed': true,
        'teacherComment': 'John is a brilliant student and consistently performs well. He has shown significant improvement in mathematics and science this term.',
        'subjects': [
          {
            'name': 'English',
            'totalMarks': 100,
            'obtainedMarks': 87,
            'percentage': 87.0,
          },
          {
            'name': 'Mathematics',
            'totalMarks': 100,
            'obtainedMarks': 92,
            'percentage': 92.0,
          },
          {
            'name': 'Science',
            'totalMarks': 100,
            'obtainedMarks': 85,
            'percentage': 85.0,
          },
          {
            'name': 'Social Studies',
            'totalMarks': 100,
            'obtainedMarks': 78,
            'percentage': 78.0,
          },
          {
            'name': 'Computer Science',
            'totalMarks': 100,
            'obtainedMarks': 93,
            'percentage': 93.0,
          }
        ],
      };

      // Convert mock data to ExamDetail object
      final examDetail = ExamDetail.fromJson(mockData);
      examDetails.value = examDetail;

      isLoading(false);
    } catch (e) {
      isLoading(false);
      error('Failed to load exam details: ${e.toString()}');
    }
  }
}