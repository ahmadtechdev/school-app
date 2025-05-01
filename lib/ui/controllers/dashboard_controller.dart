import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/api_response.dart';
import '../../data/models/dashboard.dart';
import '../../data/repositories/dashbaord_respository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  final Rx<DashboardModel?> dashboardData = Rx<DashboardModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }


  // Function to open WhatsApp with predefined message
  Future<void> openWhatsApp() async {
    final whatsappLink = dashboardData.value?.whatsappLink;

    if (whatsappLink == null || whatsappLink.isEmpty) {
      // Show error message if WhatsApp link is not available
      Get.snackbar(
        'Error',
        'WhatsApp link not available. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Predefined message for complaint
    const message = "Hello, I would like to register a complaint. ";

    // Create the WhatsApp URL with encoded message
    final encodedMessage = Uri.encodeComponent(message);
    final url = whatsappLink.contains('?')
        ? '$whatsappLink&text=$encodedMessage'
        : '$whatsappLink?text=$encodedMessage';

    final uri = Uri.parse(url);
    await launchUrl(uri);

  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    error.value = '';

    try {
      final ApiResponse<DashboardModel> response =
      await _dashboardRepository.getDashboardData();

      if (response.success && response.data != null) {
        dashboardData.value = response.data;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = 'An error occurred while fetching dashboard data';
    } finally {
      isLoading.value = false;
    }
  }

  // Method to handle refresh
  Future<void> refreshData() async {
    isLoading.value = true;
    error.value = '';

    try {
      final ApiResponse<DashboardModel> response =
      await _dashboardRepository.refreshDashboardData();

      if (response.success && response.data != null) {
        dashboardData.value = response.data;
      } else {
        error.value = response.message;
      }
    } catch (e) {
      error.value = 'An error occurred while refreshing dashboard data';
    } finally {
      isLoading.value = false;
    }
  }


}