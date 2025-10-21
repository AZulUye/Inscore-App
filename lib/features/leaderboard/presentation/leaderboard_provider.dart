import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/leaderboard/data/models/leaderboard_response.dart';
// import 'package:inscore_app/features/leaderboard/data/mock_api_service.dart';
import 'package:inscore_app/services/api_service.dart';

class LeaderboardProvider extends BaseViewModel {
  final ApiService _apiService;

  LeaderboardProvider(this._apiService);

  List<UserScore>? _userScores;

  List<UserScore> get userScores {
    if (_userScores == null) return [];
    final sortedList = List<UserScore>.from(_userScores!);
    sortedList.sort((a, b) => b.score.compareTo(a.score));
    return sortedList;
  }

  Future<void> fetchLeaderboard(String period) async {
    try {
      setLoading(true);
      final result = await _apiService.fetchLeaderboard(period);
      _userScores = result;
      setSuccess();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }
}
