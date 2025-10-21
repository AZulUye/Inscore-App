// To parse this JSON data, do
//
//     final leaderboardResponse = leaderboardResponseFromJson(jsonString);

import 'dart:convert';

import 'package:inscore_app/features/leaderboard/domain/user_score_model.dart';

LeaderboardResponse leaderboardResponseFromJson(String str) =>
    LeaderboardResponse.fromJson(json.decode(str));

String leaderboardResponseToJson(LeaderboardResponse data) =>
    json.encode(data.toJson());

class LeaderboardResponse {
  final bool success;
  final String message;
  final List<UserScoreModel> data;

  LeaderboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      LeaderboardResponse(
        success: json["success"],
        message: json["message"],
        data: List<UserScoreModel>.from(
          json["data"].map((x) => UserScoreModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
