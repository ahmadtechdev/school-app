import 'package:get/get.dart';

// Model class for Exam
class Exam {
  final String id;
  final String name;
  final String examType;
  final String date;
  final int totalMarks;
  final int obtainedMarks;
  final double percentage;
  final bool isPassed;

  Exam({
    required this.id,
    required this.name,
    required this.examType,
    required this.date,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
    required this.isPassed,
  });

  // Factory method to create Exam from JSON
  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      examType: json['examType'] ?? '',
      date: json['date'] ?? '',
      totalMarks: json['totalMarks'] ?? 0,
      obtainedMarks: json['obtainedMarks'] ?? 0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
      isPassed: json['isPassed'] ?? false,
    );
  }
}

class MarksController extends GetxController {
  final String studentId;

  // Observable variables
  var isLoading = true.obs;
  var error = ''.obs;
  var examsList = <Exam>[].obs;

  MarksController({required this.studentId});

  @override
  void onInit() {
    super.onInit();
    fetchExamsList();
  }

  Future<void> fetchExamsList() async {
    try {
      isLoading(true);
      error('');

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, we'll populate with mock data
      // In a real app, you would make an API call here
      // Example: final response = await apiService.getExams(studentId);

      // Mock data for demonstration
      final List<Map<String, dynamic>> mockData = [
        {
          'id': '1',
          'name': 'Final Term Exam 2024',
          'examType': 'Final',
          'date': 'May 1, 2024',
          'totalMarks': 500,
          'obtainedMarks': 425,
          'percentage': 85.0,
          'isPassed': true,
        },
        {
          'id': '2',
          'name': 'Mid Term Examination',
          'examType': 'Midterm',
          'date': 'Feb 15, 2024',
          'totalMarks': 300,
          'obtainedMarks': 255,
          'percentage': 85.0,
          'isPassed': true,
        },
        {
          'id': '3',
          'name': 'Monthly Test - April',
          'examType': 'Test',
          'date': 'Apr 5, 2024',
          'totalMarks': 100,
          'obtainedMarks': 78,
          'percentage': 78.0,
          'isPassed': true,
        },
        {
          'id': '4',
          'name': 'Science Quiz',
          'examType': 'Quiz',
          'date': 'Mar 20, 2024',
          'totalMarks': 50,
          'obtainedMarks': 42,
          'percentage': 84.0,
          'isPassed': true,
        },
        {
          'id': '5',
          'name': 'Winter Assessment',
          'examType': 'Term',
          'date': 'Dec 15, 2023',
          'totalMarks': 400,
          'obtainedMarks': 320,
          'percentage': 80.0,
          'isPassed': true,
        },
      ];

      // Convert mock data to list of Exam objects
      final exams = mockData.map((data) => Exam.fromJson(data)).toList();
      examsList.assignAll(exams);

      isLoading(false);
    } catch (e) {
      isLoading(false);
      error('Failed to load exams: ${e.toString()}');
    }
  }
}