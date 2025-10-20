// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_response_mock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardResponseMock _$LeaderboardResponseMockFromJson(
  Map<String, dynamic> json,
) => LeaderboardResponseMock(
  error: json['error'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => UserScore.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LeaderboardResponseMockToJson(
  LeaderboardResponseMock instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'data': instance.data,
};

UserScore _$UserScoreFromJson(Map<String, dynamic> json) => UserScore(
  name: json['name'] as String,
  score: (json['score'] as num).toInt(),
  avatarUrl: json['avatar_url'] as String,
);

Map<String, dynamic> _$UserScoreToJson(UserScore instance) => <String, dynamic>{
  'name': instance.name,
  'score': instance.score,
  'avatar_url': instance.avatarUrl,
};
