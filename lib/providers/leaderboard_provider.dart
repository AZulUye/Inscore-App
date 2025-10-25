import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/core/exception_handler.dart';
import 'package:inscore_app/features/leaderboard/data/leaderboard_repository.dart';
import 'package:inscore_app/features/leaderboard/domain/user_score_model.dart';

class LeaderboardProvider extends BaseViewModel {
  final LeaderboardRepository _repository;

  LeaderboardProvider(this._repository);

  List<UserScoreModel>? _userScores;

  List<UserScoreModel> get userScores {
    if (_userScores == null) return [];
    final sortedList = List<UserScoreModel>.from(_userScores!);
    sortedList.sort((a, b) => b.score.compareTo(a.score));
    return sortedList;
  }

  Future<void> fetchLeaderboard(String period) async {
    try {
      setLoading(true);
      final result = await _repository.fetchLeaderboard(period);
      _userScores = result;
      setSuccess();
    } catch (e) {
      final errorMsg = ExceptionHandler.getErrorMessage(e);
      setError(errorMsg);
    }
  }
}
