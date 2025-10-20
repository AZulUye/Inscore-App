import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_response_mock.g.dart';

@JsonSerializable()
class LeaderboardResponseMock {
  final bool error;
  final String message;
  final List<UserScore> data;

  LeaderboardResponseMock({
    required this.error,
    required this.message,
    required this.data,
  });

  factory LeaderboardResponseMock.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardResponseMockFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardResponseMockToJson(this);
}

@JsonSerializable()
class UserScore {
  final String name;
  final int score;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  UserScore({required this.name, required this.score, required this.avatarUrl});

  factory UserScore.fromJson(Map<String, dynamic> json) =>
      _$UserScoreFromJson(json);

  Map<String, dynamic> toJson() => _$UserScoreToJson(this);
}
