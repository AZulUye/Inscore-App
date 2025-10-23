import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/profile/domain/response_metric_facebook.dart';
import 'package:inscore_app/features/profile/domain/response_metric_instagram.dart';
import 'package:inscore_app/models/user.dart';

import '../core/base_viewmodel.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/profile/domain/score_response.dart';

class ProfileProvider extends BaseViewModel {
  final ProfileRepository _profileRepository;

  ProfileProvider(this._profileRepository);

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

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setUserData({
    required String id,
    required String name,
    required String email,
    String? avatar,
  }) {
    _currentUser = User(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> fetchUserScore() async {
    try {
      setLoading(true);
      print('🔄 Fetching user score...');

      // Check connection status first
      final instagramStatus = await _profileRepository
          .checkInstagramConnectionStatus();
      final facebookStatus = await _profileRepository
          .checkFacebookConnectionStatus();

      print('📊 Instagram connected: ${instagramStatus['connected']}');
      print('📊 Facebook connected: ${facebookStatus['connected']}');

      final result = await _profileRepository.fetchUserScore();

      // Only show scores for connected platforms
      if (instagramStatus['connected'] == true &&
          facebookStatus['connected'] == true) {
        // Both connected - show all scores from server
        _userScore = result;
        print(
          '📊 Both connected - showing full scores: Instagram=${result.instagramScore}, Facebook=${result.facebookScore}, Final=${result.finalScore}',
        );
      } else if (instagramStatus['connected'] == true) {
        // Only Instagram connected - show Instagram score, Facebook = 0, Final = server final score
        _userScore = Data(
          businessId: result.businessId,
          date: result.date,
          instagramScore: result.instagramScore,
          facebookScore: 0.0,
          finalScore: result.finalScore, // Final = server final score
          updatedAt: result.updatedAt,
          createdAt: result.createdAt,
          id: result.id,
        );
        print(
          '📊 Only Instagram connected - Instagram=${result.instagramScore}, Facebook=0, Final=${result.finalScore}',
        );
      } else if (facebookStatus['connected'] == true) {
        // Only Facebook connected - show Facebook score, Instagram = 0, Final = server final score
        _userScore = Data(
          businessId: result.businessId,
          date: result.date,
          instagramScore: 0.0,
          facebookScore: result.facebookScore,
          finalScore: result.finalScore, // Final = server final score
          updatedAt: result.updatedAt,
          createdAt: result.createdAt,
          id: result.id,
        );
        print(
          '📊 Only Facebook connected - Instagram=0, Facebook=${result.facebookScore}, Final=${result.finalScore}',
        );
      } else {
        // Neither connected - show all zeros
        _userScore = Data(
          businessId: result.businessId,
          date: result.date,
          instagramScore: 0.0,
          facebookScore: 0.0,
          finalScore: 0.0, // Final = 0
          updatedAt: result.updatedAt,
          createdAt: result.createdAt,
          id: result.id,
        );
        print('📊 Neither connected - All scores = 0');
      }

      setSuccess();
      notifyListeners();
    } catch (e) {
      print('💥 Error fetching user score: $e');
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }

  Future<void> fetchInstagramMetrics() async {
    try {
      setLoading(true);
      print('🔍 Checking Instagram connection status...');

      // First check if Instagram is connected
      final connectionStatus = await _profileRepository
          .checkInstagramConnectionStatus();
      print('📊 Instagram connection status: $connectionStatus');

      if (connectionStatus['connected'] == true) {
        // If connected, fetch metrics
        print('✅ Instagram connected, fetching metrics...');
        try {
          final result = await _profileRepository.fetchInstagramMetrics();
          _instagramMetrics = result;
          print('📈 Instagram metrics fetched successfully:');
          print('  - Username: ${result.username}');
          print('  - Followers: ${result.followers}');
          print('  - Engagement Rate: ${result.engagementRate}');
          print('  - Reach Ratio: ${result.reachRatio}');
          print('  - Engagement Per Post: ${result.engagementPerPost}');
        } catch (e) {
          print('💥 Error fetching Instagram metrics: $e');
          _instagramMetrics = null;
        }
      } else {
        // If not connected, set metrics to null
        print('❌ Instagram not connected, setting metrics to null');
        _instagramMetrics = null;
      }
      setSuccess();
      notifyListeners();
    } catch (e) {
      // If error occurs, set metrics to null
      print('💥 Error fetching Instagram metrics: $e');
      _instagramMetrics = null;
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }

  Future<void> fetchFacebookMetrics() async {
    try {
      setLoading(true);
      print('🔍 Checking Facebook connection status...');

      // First check if Facebook is connected
      final connectionStatus = await _profileRepository
          .checkFacebookConnectionStatus();
      print('📊 Facebook connection status: $connectionStatus');

      if (connectionStatus['connected'] == true) {
        // If connected, fetch metrics
        print('✅ Facebook connected, fetching metrics...');
        try {
          final result = await _profileRepository.fetchFacebookMetrics();
          _facebookMetrics = result;
          print('📈 Facebook metrics fetched successfully:');
          print('  - Username: ${result.username}');
          print('  - Followers: ${result.followers}');
          print('  - Engagement Rate: ${result.engagementRate}');
          print('  - Reach Ratio: ${result.reachRatio}');
          print('  - Engagement Per Post: ${result.engagementPerPost}');
        } catch (e) {
          print('💥 Error fetching Facebook metrics: $e');
          _facebookMetrics = null;
        }
      } else {
        // If not connected, set metrics to null
        print('❌ Facebook not connected, setting metrics to null');
        _facebookMetrics = null;
      }
      setSuccess();
      notifyListeners();
    } catch (e) {
      // If error occurs, set metrics to null
      print('💥 Error fetching Facebook metrics: $e');
      _facebookMetrics = null;
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }

  // Method to refresh metrics after social media connection
  Future<void> refreshMetrics() async {
    await fetchInstagramMetrics();
    await fetchFacebookMetrics();
  }

  // Method to refresh only Instagram metrics
  Future<void> refreshInstagramMetrics() async {
    await fetchInstagramMetrics();
  }

  // Method to refresh only Facebook metrics
  Future<void> refreshFacebookMetrics() async {
    await fetchFacebookMetrics();
  }
}
