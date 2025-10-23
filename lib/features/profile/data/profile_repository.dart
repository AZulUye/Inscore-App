import '../../../services/api_service.dart';
import '../domain/score_response.dart';
import '../domain/response_metric_instagram.dart';
import '../domain/response_metric_facebook.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<Data> fetchUserScore() async {
    return _apiService.fetchUserScore();
  }

  Future<DataInstagram> fetchInstagramMetrics() async {
    return _apiService.fetchInstagramMetrics();
  }

  Future<DataFacebook> fetchFacebookMetrics() async {
    return _apiService.fetchFacebookMetrics();
  }

  Future<Map<String, dynamic>> checkInstagramConnectionStatus() async {
    return _apiService.checkInstagramConnectionStatus();
  }

  Future<Map<String, dynamic>> checkFacebookConnectionStatus() async {
    return _apiService.checkFacebookConnectionStatus();
  }
}
