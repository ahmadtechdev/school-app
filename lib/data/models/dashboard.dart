class DashboardModel {
  final bool success;
  final String name;
  final String image;
  final String whatsappLink;
  final String instituteName;
  final int totalPendingAmount;
  final List<Student> students;

  DashboardModel({
    required this.success,
    required this.name,
    required this.image,
    required this.whatsappLink,
    required this.instituteName,
    required this.totalPendingAmount,
    required this.students,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] ?? false,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      whatsappLink: json['whatsapp_link'] ?? '',
      instituteName: json['institute_name'] ?? '',
      totalPendingAmount: json['total_pending_amount'] ?? 0,
      students: (json['students'] as List?)
          ?.map((student) => Student.fromJson(student))
          .toList() ??
          [],
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