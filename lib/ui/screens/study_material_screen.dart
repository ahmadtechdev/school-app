import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../../data/models/study_material_model.dart';
import '../controllers/study_material_controller.dart';

class StudyMaterialScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentImage;

  const StudyMaterialScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.studentImage,
  }) : super(key: key);

  @override
  State<StudyMaterialScreen> createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final StudyMaterialController _controller = Get.put(StudyMaterialController());

  @override
  void initState() {
    super.initState();

    // Initialize animations
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

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Load data
    _loadStudyMaterials();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadStudyMaterials() async {
    await _controller.loadStudyMaterials(int.parse(widget.studentId));
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
                if (_controller.isLoading.value) {
                  return _buildLoadingView();
                } else if (_controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorView(_controller.errorMessage.value);
                } else if (_controller.studyMaterials.isEmpty) {
                  return _buildEmptyView();
                } else {
                  return _buildStudyMaterialsContent();
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'Coming Soon',
            'Search and filtering functionality will be available soon!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primary.withOpacity(0.9),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
            duration: const Duration(seconds: 2),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.search, color: Colors.white),
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
                      'Study Material',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
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
                        'View Learning Resources',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/login_animation.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading study materials...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
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
            errorMessage,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadStudyMaterials,
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

  Widget _buildStudyMaterialsContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: _loadStudyMaterials,
          color: AppColors.primary,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: _controller.studyMaterials.length,
              itemBuilder: (context, index) {
                final material = _controller.studyMaterials[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildMaterialCard(material),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_box.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'No study materials available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for new resources',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadStudyMaterials,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
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

  Widget _buildMaterialCard(StudyMaterial material) {
    // Assign colors based on file type for visual distinction
    final Color cardColor = _getColorForFileType(material.fileType);
    final bool isRecent = DateTime.now().difference(material.createdAt).inDays < 7;
    final String formattedDate = DateFormat('dd-MM-yyyy').format(material.createdAt);

    return GestureDetector(
      onTap: () => _showMaterialDetails(material),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: cardColor.withOpacity(0.1),
              highlightColor: cardColor.withOpacity(0.05),
              onTap: () => _showMaterialDetails(material),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: cardColor,
                      width: 6,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _getFileTypeIcon(material.fileType, cardColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isRecent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              Text(
                                material.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Uploaded: $formattedDate',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.file_present,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              material.fileType,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadFile(material),
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Download'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () => _previewFile(material),
                            icon: const Icon(
                              Icons.visibility,
                              color: AppColors.textPrimary,
                            ),
                            tooltip: 'Preview',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForFileType(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return Colors.purple;
      case 'DOCX':
        return Colors.blue;
      case 'XLSX':
        return Colors.green;
      case 'PPTX':
        return Colors.orange;
      case 'ZIP':
        return Colors.amber;
      case 'IMAGE':
        return Colors.indigo;
      case 'VIDEO':
        return Colors.red;
      case 'AUDIO':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  Widget _getFileTypeIcon(String fileType, Color color) {
    IconData iconData;

    switch (fileType.toUpperCase()) {
      case 'PDF':
        iconData = Icons.picture_as_pdf;
        break;
      case 'DOCX':
        iconData = Icons.description;
        break;
      case 'XLSX':
        iconData = Icons.table_chart;
        break;
      case 'PPTX':
        iconData = Icons.slideshow;
        break;
      case 'ZIP':
        iconData = Icons.folder_zip;
        break;
      case 'IMAGE':
        iconData = Icons.image;
        break;
      case 'VIDEO':
        iconData = Icons.video_file;
        break;
      case 'AUDIO':
        iconData = Icons.audio_file;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Icon(
      iconData,
      color: color,
      size: 28,
    );
  }

  void _showMaterialDetails(StudyMaterial material) {
    final Color cardColor = _getColorForFileType(material.fileType);
    final String formattedDate = DateFormat('dd MMMM, yyyy').format(material.createdAt);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _getFileTypeIcon(material.fileType, cardColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        material.fileType,
                        style: TextStyle(
                          color: cardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Uploaded: $formattedDate',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.file_present,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  material.fileType,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _downloadFile(material);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _previewFile(material);
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Preview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _downloadFile(StudyMaterial material) {
    Get.snackbar(
      'Downloading',
      'Downloading ${material.title}...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.download,
        color: Colors.white,
      ),
    );

    // In real implementation, you would start the download process here
  }

  void _previewFile(StudyMaterial material) {
    Get.snackbar(
      'Preview',
      'Opening preview for ${material.title}...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.visibility,
        color: Colors.white,
      ),
    );

    // In real implementation, you would open a preview here
  }
}