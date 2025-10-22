import '../core/base_viewmodel.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../core/exception_handler.dart';

class UserProvider extends BaseViewModel {
  String? get error => isError ? errorMessage : null;
  User? _user;
  final ApiService _apiService;

  UserProvider(this._apiService);

  User? get user => _user;

  Future<void> login(String email, String password) async {
    // Auth moved to AuthProvider. Use AuthProvider.login instead.
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    // Auth moved to AuthProvider. Use AuthProvider.register instead.
  }

  Future<void> logout() async {
    // Auth moved to AuthProvider. Use AuthProvider.logout instead.
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
      final userData = await _apiService.getUser();

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

  Future<bool> isAuthenticated() async {
    // Auth moved to AuthProvider. Use AuthProvider.isAuthenticated instead.
    throw UnsupportedError('Call AuthProvider.isAuthenticated()');
  }
}
