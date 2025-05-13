import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../controllers/attendance_controller.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentImage;

  const AttendanceScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.studentImage,
  }) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final AttendanceController _controller = Get.put(
    AttendanceController(
      repository: AttendanceRepository(apiService: ApiService()),
    ),
  );

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuint,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Calculate statistics based on real data
  int get _totalSchoolDays => _controller.attendanceData
      .where((record) => record.status != 'Not Taken')
      .length;

  int get _totalPresent => _controller.totalPresents.value;
  int get _totalAbsent => _totalSchoolDays - _totalPresent;
  double get _attendancePercentage => _totalSchoolDays > 0
      ? (_totalPresent / _totalSchoolDays) * 100
      : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() => _controller.isLoading.value
                  ? _buildLoadingView()
                  : _controller.errorMessage.value.isNotEmpty
                  ? _buildErrorView()
                  : _buildAttendanceContent()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Attendance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance for back button
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Hero(
                  tag: 'student_${widget.studentId}_image',
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.studentImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'View Attendance Records',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'Loading attendance data...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _controller.errorMessage.toString(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _controller.loadAttendance,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: () => _controller.loadAttendance(),
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              _buildCalendarCard(),
              const SizedBox(height: 20),
              _buildAttendanceSummary(),
              const SizedBox(height: 20),
              _buildMonthlyStatistics(),
            ],
          ),
        ),
      ),
    );
  }

  // Update the calendar widget to handle month changes
  Widget _buildCalendarCard() {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            elevation: AppConstants.defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedDay),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          _buildLegendItem('Present', Colors.green),
                          const SizedBox(width: 12),
                          _buildLegendItem('Absent', Colors.red),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TableCalendar(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _controller.changeMonth(focusedDay.month, focusedDay.year);
                      });
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });

                      final attendanceRecord = _controller.attendanceData.firstWhere(
                            (record) => isSameDay(record.date, selectedDay),
                        orElse: () => AttendanceRecord(date: selectedDay, status: 'Not Taken'),
                      );

                      if (attendanceRecord.status != 'Not Taken') {
                        Get.snackbar(
                          DateFormat('EEEE, d MMMM').format(selectedDay),
                          'Status: ${attendanceRecord.status}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: attendanceRecord.status == 'Present'
                              ? Colors.green.withOpacity(0.9)
                              : Colors.red.withOpacity(0.9),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 12,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildCalendarDay(day);
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary),
                      rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary),
                      titleTextStyle: TextStyle(fontSize: 0),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      holidayTextStyle: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCalendarDay(DateTime day) {
    final attendanceRecord = _controller.attendanceData.firstWhere(
          (record) => isSameDay(record.date, day),
      orElse: () => AttendanceRecord(date: day, status: 'Not Taken'),
    );

    if (attendanceRecord.status != 'Not Taken') {
      final bool isPresent = attendanceRecord.status == 'Present';
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPresent ? Colors.green.withOpacity(0.85) : Colors.red.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isPresent
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Update statistics widgets to use the calculated values
  Widget _buildAttendanceSummary() {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttendanceStat(
                      icon: Icons.check_circle,
                      color: Colors.green,
                      label: 'Present',
                      value: _totalPresent.toString(),
                    ),
                    _buildAttendanceStat(
                      icon: Icons.cancel,
                      color: Colors.red,
                      label: 'Absent',
                      value: _totalAbsent.toString(),
                    ),
                    _buildAttendanceStat(
                      icon: Icons.calendar_today,
                      color: Colors.amber,
                      label: 'Total Days',
                      value: _totalSchoolDays.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Attendance Rate',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_attendancePercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildProgressBar(_attendancePercentage / 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStat({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            color: _getAttendanceColor(percentage),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 0.9) {
      return Colors.green;
    } else if (percentage >= 0.75) {
      return Colors.lightGreen;
    } else if (percentage >= 0.6) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  Widget _buildMonthlyStatistics() {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 700),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getAttendanceRatingColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getAttendanceRating(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: AppColors.info,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getAttendanceMessage(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_attendancePercentage < 75)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Attendance Warning',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Low attendance may affect academic performance. Minimum required attendance is 75%.',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                ),
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
      ),
    );
  }

  String _getAttendanceRating() {
    if (_attendancePercentage >= 90) {
      return 'Excellent';
    } else if (_attendancePercentage >= 80) {
      return 'Good';
    } else if (_attendancePercentage >= 75) {
      return 'Average';
    } else {
      return 'Poor';
    }
  }

  Color _getAttendanceRatingColor() {
    if (_attendancePercentage >= 90) {
      return Colors.green;
    } else if (_attendancePercentage >= 80) {
      return Colors.lightGreen;
    } else if (_attendancePercentage >= 75) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  String _getAttendanceMessage() {
    if (_attendancePercentage >= 90) {
      return 'Excellent attendance record! Keep up the good work.';
    } else if (_attendancePercentage >= 80) {
      return 'Good attendance record. Regular attendance helps with academic progress.';
    } else if (_attendancePercentage >= 75) {
      return 'Average attendance. Try to improve attendance for better academic results.';
    } else {
      return 'Poor attendance. Please ensure regular attendance to avoid academic difficulties.';
    }
  }
}