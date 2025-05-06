import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';

class HomeworkDiaryScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentImage;

  const HomeworkDiaryScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.studentImage,
  }) : super(key: key);

  @override
  State<HomeworkDiaryScreen> createState() => _HomeworkDiaryScreenState();
}

class _HomeworkDiaryScreenState extends State<HomeworkDiaryScreen> with TickerProviderStateMixin {
  late DateTime _selectedDate;
  late TabController _tabController;
  late AnimationController _fadeController;
  final List<DateTime> _weekDates = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // This will be replaced with actual API data later
  final RxList<HomeworkItem> _homeworkItems = <HomeworkItem>[].obs;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDates();
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: _getInitialTabIndex(),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadHomeworkData();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fadeController.reverse();
      } else {
        _onDateChanged(_weekDates[_tabController.index]);
        _fadeController.forward();
      }
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _generateWeekDates() {
    _weekDates.clear();
    // Get the first day of current week (Saturday)
    final DateTime firstDayOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday % 7),
    );

    // Generate dates for the week
    for (int i = 0; i < 7; i++) {
      _weekDates.add(firstDayOfWeek.add(Duration(days: i)));
    }
  }

  int _getInitialTabIndex() {
    // Find today's index in the week dates
    for (int i = 0; i < _weekDates.length; i++) {
      if (_weekDates[i].day == _selectedDate.day &&
          _weekDates[i].month == _selectedDate.month &&
          _weekDates[i].year == _selectedDate.year) {
        return i;
      }
    }
    return 0;
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadHomeworkData();
    });
  }

  void _loadHomeworkData() {
    // This method will be replaced with actual API call later
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulating API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Mocking data for now - this will be replaced with real API data
      if (_selectedDate.day % 3 == 0) {
        // Empty state for some days
        _homeworkItems.clear();
      } else {
        _homeworkItems.value = [
          HomeworkItem(
            id: '1',
            subject: 'English',
            title: 'Essay Writing',
            description: 'Write a 500-word essay on "The Importance of Education"',
            teacherName: 'Mr. Johnson',
            hasAttachment: false,
            color: Colors.cyan,
            icon: Icons.book,
          ),
          HomeworkItem(
            id: '2',
            subject: 'Math',
            title: 'Algebra Practice',
            description: 'Complete exercises 5-10 on page 45 of the textbook. Focus on quadratic equations.',
            teacherName: 'Mrs. Smith',
            hasAttachment: false,
            color: Colors.blue,
            icon: Icons.calculate,
          ),
          HomeworkItem(
            id: '3',
            subject: 'Physics',
            title: 'Force and Motion',
            description: 'Prepare a presentation on Newton\'s laws of motion with practical examples.',
            teacherName: 'Dr. Williams',
            hasAttachment: false,
            color: Colors.orange,
            icon: Icons.science,
          ),
          HomeworkItem(
            id: '4',
            subject: 'Chemistry',
            title: 'Periodic Table',
            description: 'Study the properties of elements in groups 1 and 2. Prepare for a quiz next class.',
            teacherName: 'Ms. Garcia',
            hasAttachment: true,
            attachmentUrl: 'https://example.com/periodic_table.pdf',
            attachmentName: 'periodic_table.pdf',
            color: Colors.deepOrange,
            icon: Icons.biotech,
          ),
          HomeworkItem(
            id: '5',
            subject: 'History',
            title: 'World War II',
            description: 'Research the causes and effects of World War II. Submit a 2-page report.',
            teacherName: 'Mr. Brown',
            hasAttachment: true,
            attachmentUrl: 'https://example.com/ww2_guidelines.pdf',
            attachmentName: 'ww2_guidelines.pdf',
            color: Colors.brown,
            icon: Icons.history_edu,
          ),
        ];
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _navigateToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _generateWeekDates();
      _tabController.animateTo(_getInitialTabIndex());
    });
  }

  void _navigateToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _generateWeekDates();
      _tabController.animateTo(_getInitialTabIndex());
    });
  }

  void _downloadAttachment(String url, String fileName) {
    // This will be implemented with proper file download functionality
    Get.snackbar(
      'Downloading',
      'Downloading $fileName...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildDateSelector(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeController,
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                  ? _buildErrorState()
                  : _homeworkItems.isEmpty
                  ? _buildEmptyState()
                  : _buildHomeworkList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
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
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'Homework Diary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Hero(
                tag: 'student_${widget.studentId}',
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.studentImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.studentName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.school,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                widget.studentName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    const List<String> weekdays = ['SAT', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this to ensure column takes minimum space
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _navigateToPreviousWeek,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              Expanded( // Wrap in Expanded to handle long text
                child: Text(
                  '${DateFormat('MMMM yyyy').format(_weekDates.first)} - ${_weekDates.first.month != _weekDates.last.month ? DateFormat('MMMM yyyy').format(_weekDates.last) : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center, // Center the text
                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                ),
              ),
              IconButton(
                onPressed: _navigateToNextWeek,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Remove fixed height container and let content determine height
          SingleChildScrollView( // Make horizontally scrollable if needed
            scrollDirection: Axis.horizontal,
            child: Row( // Use Row instead of TabBar for simpler implementation
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                    (index) {
                  final date = _weekDates[index];
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _tabController.animateTo(index);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: !isSelected ? Border.all(color: Colors.grey.shade300) : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Use minimum vertical space
                        children: [
                          Text(
                            weekdays[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
              strokeWidth: 5,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading homework assignments...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
            color: AppColors.error.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            _errorMessage,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadHomeworkData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Try Again'),
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book,
              size: 60,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No homework for ${DateFormat('EEEE, MMMM d').format(_selectedDate)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Enjoy your free time! Select another date to check homework.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _loadHomeworkData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkList() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _homeworkItems.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final homework = _homeworkItems[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildHomeworkCard(homework),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkItem homework) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subject header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: homework.color.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  homework.icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    homework.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    homework.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assignment',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  homework.description,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Assigned by: ${homework.teacherName}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (homework.hasAttachment) _buildAttachmentSection(homework),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSection(HomeworkItem homework) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.attach_file,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              homework.attachmentName ?? 'Attachment',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () => _downloadAttachment(
              homework.attachmentUrl ?? '',
              homework.attachmentName ?? 'file',
            ),
            icon: const Icon(
              Icons.download,
              size: 16,
            ),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeworkItem {
  final String id;
  final String subject;
  final String title;
  final String description;
  final String teacherName;
  final bool hasAttachment;
  final String? attachmentUrl;
  final String? attachmentName;
  final Color color;
  final IconData icon;

  HomeworkItem({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.teacherName,
    required this.hasAttachment,
    this.attachmentUrl,
    this.attachmentName,
    required this.color,
    required this.icon,
  });
}