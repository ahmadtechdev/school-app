import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../models/api_response.dart';
import '../models/dashboard.dart';

class DashboardRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Get dashboard data
  Future<ApiResponse<DashboardModel>> getDashboardData() async {
    try {
      // Make API call through the ApiService
      final response = await _apiService.getDashboardData();

      // Return the response directly since processing is done in ApiService
      return response;
    } catch (e) {
      // Handle any exceptions
      return ApiResponse<DashboardModel>(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  // Method to refresh dashboard data
  Future<ApiResponse<DashboardModel>> refreshDashboardData() async {
    try {
      // Clear any cached data if needed
      // await _storageService.clearDashboardCache();

      // Get fresh data
      return await getDashboardData();
    } catch (e) {
      return ApiResponse<DashboardModel>(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}