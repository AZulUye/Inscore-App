import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/profile/data/models/response_metric_facebook.dart';
import 'package:inscore_app/features/profile/data/models/response_metric_instagram.dart';
import 'package:inscore_app/models/user.dart';

import '../../../core/base_viewmodel.dart';
import '../../../services/api_service.dart';
import '../../profile/data/models/score_response.dart';

class ProfileProvider extends BaseViewModel {
  final ApiService _apiService;

  ProfileProvider(this._apiService);

  User? _currentUser;
  Data? _userScore;
  DataInstagram? _instagramMetrics;
  DataFacebook? _facebookMetrics;

  User? get currentUser => _currentUser;
  Data? get userScore => _userScore;

  DataInstagram? get instagramMetrics => _instagramMetrics;
  DataFacebook? get facebookMetrics => _facebookMetrics;

  void initProfile(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> fetchUserScore() async {
    try {
      setLoading(true);
      final result = await _apiService.fetchUserScore();
      _userScore = result;
      setSuccess();
      notifyListeners();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }

  Future<void> fetchInstagramMetrics() async {
    try {
      setLoading(true);
      final result = await _apiService.fetchInstagramMetrics();
      _instagramMetrics = result;
      setSuccess();
      notifyListeners();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }

  Future<void> fetchFacebookMetrics() async {
    try {
      setLoading(true);
      final result = await _apiService.fetchFacebookMetrics();
      _facebookMetrics = result;
      setSuccess();
      notifyListeners();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }
}
