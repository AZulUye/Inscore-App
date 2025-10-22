import '../core/base_viewmodel.dart';
import '../features/auth/data/auth_repository.dart';
import '../core/exception_handler.dart';
import '../core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthProvider extends BaseViewModel {
  final AuthRepository _authService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  User? _user;

  AuthProvider(this._authService);

  User? get user => _user;

  String? get error => isError ? errorMessage : null;

  Future<void> login(String email, String password) async {
    try {
      setLoading(true);
      final loginData = await _authService.login(email, password);

      final userJson = loginData['user'] as Map<String, dynamic>;
      final token = loginData['sanctum_token'] as String?;
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      await _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: token,
      );
      _authService.setAuthorizationHeader(token);

      _user = User(
        id: userJson['id'].toString(),
        name: userJson['name'] ?? '',
        email: userJson['email'] ?? '',
        avatar: userJson['avatar_url'] ?? '',
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
    required String passwordConfirmation,
  }) async {
    try {
      setLoading(true);

      await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

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
      try {
        await _authService.logout();
      } catch (e) {
        // Server logout failed, but proceed with client cleanup
        // We intentionally don't rethrow to ensure user is signed out locally
      }

      await _secureStorage.delete(key: AppConstants.accessTokenKey);
      _authService.removeAuthorizationHeader();

      _user = null;
      setIdle();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      _authService.setAuthorizationHeader(token);
      try {
        final userData = await _authService.getUser();
        _user = User.fromJson(userData);
        setSuccess();
      } catch (e) {
        _user = null;
        setError('Gagal fetch user');
      }
    } else {
      _user = null;
    }
    return _user != null;
  }

  Future<void> forgotPassword(String email) async {
    try {
      setLoading(true);
      await _authService.forgotPassword(email);
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarPath,
  }) async {
    try {
      setLoading(true);
      final response = await _authService.updateProfile(
        name: name,
        email: email,
        avatarPath: avatarPath,
      );

      // Update user data with response
      _user = User.fromJson(response);
      setSuccess();
    } catch (e) {
      final errorMessage = ExceptionHandler.getErrorMessage(e);
      setError(errorMessage);
      rethrow;
    }
  }
}
