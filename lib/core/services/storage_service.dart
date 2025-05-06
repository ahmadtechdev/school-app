import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init();
  }

  // Generic methods to read/write/delete data
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  Future<void> delete(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Specific methods for auth
  Future<void> saveAuthToken(String token) async {
    await write(AppConstants.authTokenKey, token);
  }

  String? getAuthToken() {
    return read<String>(AppConstants.authTokenKey);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await write(AppConstants.userDataKey, userData);
  }

  Map<String, dynamic>? getUserData() {
    return read<Map<String, dynamic>>(AppConstants.userDataKey);
  }

  Future<void> setLoggedIn(bool value) async {
    await write(AppConstants.isLoggedInKey, value);
  }

  bool isLoggedIn() {
    final value = read<bool>(AppConstants.isLoggedInKey);
    print('isLoggedIn check: $value'); // Debug print
    return value ?? false;
  }
}