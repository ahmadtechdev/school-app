import 'package:get_storage/get_storage.dart';

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
    await write('auth_token', token);
  }

  String? getAuthToken() {
    return read<String>('auth_token');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await write('user_data', userData);
  }

  Map<String, dynamic>? getUserData() {
    return read<Map<String, dynamic>>('user_data');
  }

  Future<void> setLoggedIn(bool value) async {
    await write('is_logged_in', value);
  }

  bool isLoggedIn() {
    return read<bool>('is_logged_in') ?? false;
  }
}