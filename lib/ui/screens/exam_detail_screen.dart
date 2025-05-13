import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../../data/models/exams_model.dart';
import '../controllers/exam_details_controller.dart';

class ExamDetailsScreen extends StatefulWidget {
  final String examId;
  final String examName;
  final String studentId;
  final String studentName;
  final String studentImage;

  const ExamDetailsScreen({
    super.key,
    required this.examId,
    required this.examName,
    required this.studentName,
    required this.studentId,
    required this.studentImage,
  });

  @override
  State<ExamDetailsScreen> createState() => _ExamDetailsScreenState();
}

class _ExamDetailsScreenState extends State<ExamDetailsScreen> with SingleTickerProviderStateMixin {
  late ExamDetailsController _examDetailsController;
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _examDetailsController = Get.put(ExamDetailsController(examId: int.parse(widget.examId), studentId: int.parse(widget.studentId)));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (_examDetailsController.isLoading.value) {
                  return _buildLoadingState();
                }

                if (_examDetailsController.error.value.isNotEmpty) {
                  return _buildErrorState();
                }

                if (_examDetailsController.examDetails.value == null) {
                  return _buildEmptyState();
                }

                return _buildExamDetails();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(_headerAnimation),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: 'exam_name_${widget.examId}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.examName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.studentImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: const Icon(
                          Icons.school,
                          size: 25,
                          color: AppColors.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white,
                        child: const Icon(
                          Icons.school,
                          size: 25,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.studentName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Exam Report Card',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Share functionality
                      Get.snackbar(
                        'Share',
                        'Share functionality will be implemented soon',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Download functionality
                      Get.snackbar(
                        'Download',
                        'Download functionality will be implemented soon',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/error_animation.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _examDetailsController.error.value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _examDetailsController.fetchExamDetails,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/empty_animation.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No exam details found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'There might be an issue retrieving the exam details',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _examDetailsController.fetchExamDetails,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamDetails() {
    final examDetails = _examDetailsController.examDetails.value!;


    return FadeTransition(
      opacity: _contentAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_contentAnimation),
        child: RefreshIndicator(
          onRefresh: () async {
            await _examDetailsController.fetchExamDetails();
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Basic Info Section
                _buildStudentInfoCard(examDetails),

                const SizedBox(height: 20),

                // Performance Summary Section
                _buildPerformanceSummary(examDetails),

                const SizedBox(height: 20),

                // Subjects Section
                _buildSubjectsSection(examDetails),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Update the _buildStudentInfoCard method:
  Widget _buildStudentInfoCard(ExamDetailsResponse examDetails) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildInfoRow('Roll Number', examDetails.student.rollNo ?? 'N/A'),
                _buildInfoRow('Class/Grade', examDetails.student.className ?? 'N/A'),
                _buildInfoRow('Date of Birth', examDetails.student.dateOfBirth ?? 'N/A'),
                _buildInfoRow('Father\'s Name', examDetails.student.fatherName ?? 'N/A'),
                _buildInfoRow('Mother\'s Name', examDetails.student.motherName ?? 'N/A'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

// Update the _buildPerformanceSummary method:
  Widget _buildPerformanceSummary(ExamDetailsResponse examDetails) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 12),
                child: Text(
                  'Overall Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPerformanceIndicator(
                          'Total Marks',
                          '${examDetails.totalMarks}',
                          Icons.assessment,
                          AppColors.primary,
                        ),
                        _buildPerformanceIndicator(
                          'Obtained',
                          '${examDetails.totalObtainedMarks}',
                          Icons.done_all,
                          AppColors.accent,
                        ),
                        _buildPerformanceIndicator(
                          'Percentage',
                          '${examDetails.totalPercentage.toStringAsFixed(2)}%',
                          Icons.percent,
                          _getPerformanceColor(examDetails.totalPercentage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildPerformanceChart(examDetails),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPerformanceIndicator(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceChart(dynamic examDetails) {
    // Sample data for the performance chart
    // In a real app, this would come from the examDetails
    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.blueGrey.shade800,
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String subjectName = '';
                double percentage = 0;

                // In a real app, this would use actual data from examDetails
                switch (groupIndex) {
                  case 0:
                    subjectName = 'English';
                    percentage = 87;
                    break;
                  case 1:
                    subjectName = 'Math';
                    percentage = 65;
                    break;
                  case 2:
                    subjectName = 'Science';
                    percentage = 75;
                    break;
                  case 3:
                    subjectName = 'History';
                    percentage = 82;
                    break;
                  case 4:
                    subjectName = 'Art';
                    percentage = 90;
                    break;
                }

                return BarTooltipItem(
                  '$subjectName\n${percentage.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = 'Eng';
                      break;
                    case 1:
                      text = 'Math';
                      break;
                    case 2:
                      text = 'Sci';
                      break;
                    case 3:
                      text = 'His';
                      break;
                    case 4:
                      text = 'Art';
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
            drawVerticalLine: false,
          ),
          barGroups: [
            _buildBarGroup(0, 87, AppColors.primary),
            _buildBarGroup(1, 65, AppColors.warning),
            _buildBarGroup(2, 75, AppColors.info),
            _buildBarGroup(3, 82, AppColors.accent),
            _buildBarGroup(4, 90, AppColors.success),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Update the _buildSubjectsSection method:
  Widget _buildSubjectsSection(ExamDetailsResponse examDetails) {
    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 700),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 12),
                child: Text(
                  'Subject Wise Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Subject',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Total\nMarks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Obtained\nMarks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Percentage',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Content
                    ...examDetails.resultCard.map((subject) {
                      final percentage = double.tryParse(subject.percentage) ?? 0;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  subject.subject,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  subject.totalMarks,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  subject.obtainedMarks,
                                  style: TextStyle(
                                    color: subject.obtainedMarks != '0'
                                        ? AppColors.textPrimary
                                        : AppColors.error,
                                    fontWeight: subject.obtainedMarks != '0'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  subject.percentage != 'N/A' && subject.percentage != '0'
                                      ? '${percentage.toStringAsFixed(1)}%'
                                      : 'N/A',
                                  style: TextStyle(
                                    color: subject.percentage != 'N/A' && subject.percentage != '0'
                                        ? _getPerformanceColor(percentage)
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    // Total Marks Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Marks',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${examDetails.totalObtainedMarks}/${examDetails.totalMarks}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Percentage',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${examDetails.totalPercentage.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: _getPerformanceColor(examDetails.totalPercentage),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Result',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: examDetails.totalPercentage >= 40
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  examDetails.totalPercentage >= 40 ? 'PASSED' : 'FAILED',
                                  style: TextStyle(
                                    color: examDetails.totalPercentage >= 40
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Color _getPerformanceColor(double percentage) {
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 60) {
      return AppColors.info;
    } else if (percentage >= 40) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}