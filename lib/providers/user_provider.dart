import '../core/base_viewmodel.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../core/exception_handler.dart';

class UserProvider extends BaseViewModel {
  User? _user;
  final ApiService _apiService = ApiService();

  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      setLoading();
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual API call
      final userData = await _apiService.login(email, password);
      
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
      setLoading();
      
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
      setLoading();
      
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
      setLoading();
      
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
