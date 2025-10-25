import 'package:dio/dio.dart';
import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/leaderboard/domain/leaderboard_response.dart';
import 'package:inscore_app/features/leaderboard/domain/user_score_model.dart';
import 'package:inscore_app/services/api_service.dart';

class LeaderboardRepository {
  final ApiService _apiService;

  LeaderboardRepository(this._apiService);

  // fetch all user scores for leaderboard screen
  Future<List<UserScoreModel>> fetchLeaderboard(String period) async {
    try {
      final response = await _apiService.get("/leaderboard/$period");

      final result = LeaderboardResponse.fromJson(response.data);

      if (!result.success) {
        throw ExceptionHandler.handleGenericException(result.message);
      }

      return result.data;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    } catch (e) {
      throw ExceptionHandler.handleGenericException(e);
    }
  }
}
