import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';


class NoticeBoardScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentImage;

  const NoticeBoardScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.studentImage,
  }) : super(key: key);

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> with TickerProviderStateMixin {
  late NoticeBoardController _noticeBoardController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize and inject the notice board controller
    _noticeBoardController = Get.put(NoticeBoardController(studentId: widget.studentId));

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animationController.forward();

    // Fetch notice board data
    // In a real implementation, this would be:
    // _noticeBoardController.fetchNotices();

    // For now, we'll use dummy data
    _noticeBoardController.loadDummyData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
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
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                if (_noticeBoardController.isLoading.value) {
                  return _buildLoadingView();
                }

                if (_noticeBoardController.error.value.isNotEmpty) {
                  return _buildErrorView();
                }

                if (_noticeBoardController.filteredNotices.isEmpty) {
                  return _buildEmptyView();
                }

                return _buildNoticesList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    size: 16,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Notice Board',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 32), // For alignment
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Hero(
                tag: 'student_${widget.studentId}',
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.studentImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Latest announcements and updates',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Notices',
          hintStyle: TextStyle(color: AppColors.textHint),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _isSearching
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.primary),
            onPressed: () {
              _searchController.clear();
              _noticeBoardController.searchNotices('');
              setState(() {
                _isSearching = false;
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
          _noticeBoardController.searchNotices(value);
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading notices...',
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
          const Icon(
            Icons.error_outline,
            size: 60,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            _noticeBoardController.error.value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _noticeBoardController.loadDummyData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notification_important_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isSearching ? 'No notices found matching your search' : 'No notices available yet',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_isSearching) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _noticeBoardController.searchNotices('');
                setState(() {
                  _isSearching = false;
                });
              },
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoticesList() {
    return AnimationLimiter(
      child: RefreshIndicator(
        onRefresh: () async {
          await _noticeBoardController.loadDummyData();
        },
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _noticeBoardController.filteredNotices.length,
          itemBuilder: (context, index) {
            final notice = _noticeBoardController.filteredNotices[index];
            final colorIndex = index % 4;
            final colors = [
              Colors.purple,
              Colors.teal,
              Colors.blue,
              Colors.deepOrange,
            ];
            final color = colors[colorIndex];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 300 + (index * 50)),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildNoticeCard(notice, color),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showNoticeDetails(notice),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          notice.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.description,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd MMM yyyy').format(notice.date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (notice.hasAttachment)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attachment,
                                    size: 14,
                                    color: color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Attachment',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNoticeDetails(Notice notice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notice.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM yyyy').format(notice.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
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

              const Divider(height: 1),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.description,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Attachment if available
              if (notice.hasAttachment)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadAttachment(notice.attachmentUrl ?? ''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.download),
                    label: const Text('Download Attachment'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _downloadAttachment(String url) async {
    // In a real app, you would implement proper file download logic
    // For now, we'll just simulate with a snackbar
    try {
      // Show loading indicator
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Downloading attachment...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Simulate delay
      await Future.delayed(const Duration(seconds: 2));

      // Close dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Attachment downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.back(); // Close dialog
      Get.snackbar(
        'Error',
        'Failed to download attachment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }
}

// Model class for Notice
class Notice {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool hasAttachment;
  final String? attachmentUrl;
  final String? attachmentName;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.hasAttachment = false,
    this.attachmentUrl,
    this.attachmentName,
  });
}

// Controller for Notice Board
class NoticeBoardController extends GetxController {
  final String studentId;

  var isLoading = false.obs;
  var error = ''.obs;
  var notices = <Notice>[].obs;
  var filteredNotices = <Notice>[].obs;

  NoticeBoardController({required this.studentId});

  Future<List<Notice>> loadDummyData() async {
    isLoading.value = true;
    error.value = '';

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

      final dummyNotices = [
        Notice(
          id: '1',
          title: 'Annual Sports Day',
          description: 'Dear parents, we are excited to announce our Annual Sports Day will be held on May 15th, 2025...',
          date: DateTime(2025, 5, 1),
          hasAttachment: true,
          attachmentUrl: 'https://example.com/sports_day_schedule.pdf',
          attachmentName: 'Sports Day Schedule.pdf',
        ),
        Notice(
          id: '2',
          title: 'Parent-Teacher Meeting',
          description: 'The Parent-Teacher Meeting for this semester is scheduled for May 10th, 2025...',
          date: DateTime(2025, 4, 25),
          hasAttachment: true,
          attachmentUrl: 'https://example.com/ptm_schedule.pdf',
          attachmentName: 'PTM Schedule.pdf',
        ),
        Notice(
          id: '3',
          title: 'Summer Vacation Announcement',
          description: 'Summer vacation will begin from June 1st, 2025...',
          date: DateTime(2025, 4, 15),
          hasAttachment: false,
        ),
        Notice(
          id: '4',
          title: 'Fee Payment Reminder',
          description: 'This is a gentle reminder that the fees for the next quarter are due by May 20th, 2025...',
          date: DateTime(2025, 4, 10),
          hasAttachment: false,
        ),
        Notice(
          id: '5',
          title: 'Science Exhibition',
          description: 'A Science Exhibition is being organized on April 28th, 2025...',
          date: DateTime(2025, 4, 5),
          hasAttachment: true,
          attachmentUrl: 'https://example.com/science_exhibition_guidelines.pdf',
          attachmentName: 'Science Exhibition Guidelines.pdf',
        ),
      ];

      notices.value = dummyNotices;
      filteredNotices.value = dummyNotices;
      isLoading.value = false;

      return dummyNotices;
    } catch (e) {
      error.value = 'Failed to load notices. Please try again.';
      isLoading.value = false;
      return [];
    }
  }


  void searchNotices(String query) {
    if (query.isEmpty) {
      filteredNotices.value = notices;
      return;
    }

    filteredNotices.value = notices.where((notice) {
      return notice.title.toLowerCase().contains(query.toLowerCase()) ||
          notice.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // In a real app, you'd have a method like this to fetch actual data
  Future<void> fetchNotices() async {
    try {
      isLoading.value = true;
      error.value = '';

      // API call would go here
      // final response = await apiService.getNotices(studentId);
      // notices.value = response.notices;
      // filteredNotices.value = notices;

      isLoading.value = false;
    } catch (e) {
      error.value = 'Failed to load notices. Please try again.';
      isLoading.value = false;
    }
  }
}