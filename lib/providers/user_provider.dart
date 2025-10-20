import '../core/base_viewmodel.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../core/exception_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends BaseViewModel {
  String? get error => isError ? errorMessage : null;
  User? _user;
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      setLoading(true);
      final loginData = await _apiService.login(email, password);
      // loginData: { user: {...}, sanctum_token: "..." }
      final userJson = loginData['user'] as Map<String, dynamic>;
      final token = loginData['sanctum_token'] as String?;
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }
      // Simpan token ke secure storage
      await _secureStorage.write(key: 'access_token', value: token);
      // Parsing user, sesuaikan field jika perlu
      _user = User(
        id: userJson['id'].toString(),
        name: userJson['name'] ?? '',
        email: userJson['email'] ?? '',
        avatar: userJson['avatar_url'],
        createdAt: DateTime.parse(userJson['created_at']),
        updatedAt: DateTime.parse(userJson['updated_at']),
      );
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Replace with actual API call
      final userData = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      _user = User.fromJson(userData);
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      setLoading(true);

      // TODO: Call logout API if needed
      await _apiService.logout();

      _user = null;
      setIdle();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    try {
      setLoading(true);

      // TODO: Replace with actual API call
      final userData = await _apiService.updateUser(updatedUser.toJson());

      _user = User.fromJson(userData);
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
      rethrow;
    }
  }

  Future<void> refreshUser() async {
    if (_user == null) return;

    try {
      setLoading(true);

      // TODO: Replace with actual API call
      final userData = await _apiService.getUser(_user!.id);

      _user = User.fromJson(userData);
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
    }
  }

  void clearUser() {
    _user = null;
    setIdle();
  }

  bool get isAuthenticated => _user != null;
}
