import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/leaderboard/data/models/leaderboard_response_mock.dart';
import 'package:inscore_app/features/leaderboard/data/mock_api_service.dart';

class LeaderboardProvider extends BaseViewModel {
  final MockApiService _apiService = MockApiService();

  List<UserScore>? _userScores;

  List<UserScore> get userScores {
    if (_userScores == null) return [];
    final sortedList = List<UserScore>.from(_userScores!);
    sortedList.sort((a, b) => b.score.compareTo(a.score));
    return sortedList;
  }

  Future<void> fetchLeaderboard(String period) async {
    try {
      setLoading();
      final result = await _apiService.fetchLeaderboard(period);
      _userScores = result;
      setSuccess();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }
}
