// To parse this JSON data, do
//
//     final leaderboardResponse = leaderboardResponseFromJson(jsonString);

import 'dart:convert';

LeaderboardResponse leaderboardResponseFromJson(String str) =>
    LeaderboardResponse.fromJson(json.decode(str));

String leaderboardResponseToJson(LeaderboardResponse data) =>
    json.encode(data.toJson());

class LeaderboardResponse {
  final bool success;
  final String message;
  final List<UserScore> data;

  LeaderboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      LeaderboardResponse(
        success: json["success"],
        message: json["message"],
        data: List<UserScore>.from(
          json["data"].map((x) => UserScore.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserScore {
  final String name;
  final double score;
  final String? avatarUrl;

  UserScore({required this.name, required this.score, required this.avatarUrl});

  factory UserScore.fromJson(Map<String, dynamic> json) => UserScore(
    name: json["name"],
    score: json["score"]?.toDouble(),
    avatarUrl:
        json["avatar_url"] ??
        "https://picsum.photos/120", // add template image for null data
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "score": score,
    "avatar_url": avatarUrl,
  };
}
