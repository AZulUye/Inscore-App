import 'dart:convert';

class ResponseMetricInstagram {
  bool success;
  String message;
  DataInstagram data;

  ResponseMetricInstagram({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResponseMetricInstagram.fromRawJson(String str) =>
      ResponseMetricInstagram.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseMetricInstagram.fromJson(Map<String, dynamic> json) =>
      ResponseMetricInstagram(
        success: json["success"],
        message: json["message"],
        data: DataInstagram.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class DataInstagram {
  int id;
  int socialAccountId;
  String provider;
  DateTime date;
  int followers;
  int mediaCount;
  int totalLikes;
  int totalComments;
  int totalShares;
  int totalReach;
  double engagementRate;
  double reachRatio;
  double engagementPerPost;
  int postCount;
  DateTime createdAt;
  DateTime updatedAt;
  String username;

  DataInstagram({
    required this.id,
    required this.socialAccountId,
    required this.provider,
    required this.date,
    required this.followers,
    required this.mediaCount,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.totalReach,
    required this.engagementRate,
    required this.reachRatio,
    required this.engagementPerPost,
    required this.postCount,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
  });

  factory DataInstagram.fromRawJson(String str) =>
      DataInstagram.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataInstagram.fromJson(Map<String, dynamic> json) => DataInstagram(
    id: (json["id"] ?? 0).toInt(),
    socialAccountId: (json["social_account_id"] ?? 0).toInt(),
    provider: json["provider"] ?? "",
    date: DateTime.parse(json["date"]),
    followers: (json["followers"] ?? 0).toInt(),
    mediaCount: (json["media_count"] ?? 0).toInt(),
    totalLikes: (json["total_likes"] ?? 0).toInt(),
    totalComments: (json["total_comments"] ?? 0).toInt(),
    totalShares: (json["total_shares"] ?? 0).toInt(),
    totalReach: (json["total_reach"] ?? 0).toInt(),
    engagementRate: (json["engagement_rate"] ?? 0).toDouble(),
    reachRatio: (json["reach_ratio"] ?? 0).toDouble(),
    engagementPerPost: (json["engagement_per_post"] ?? 0).toDouble(),
    postCount: (json["post_count"] ?? 0).toInt(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    username: json["username"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "social_account_id": socialAccountId,
    "provider": provider,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "followers": followers,
    "media_count": mediaCount,
    "total_likes": totalLikes,
    "total_comments": totalComments,
    "total_shares": totalShares,
    "total_reach": totalReach,
    "engagement_rate": engagementRate,
    "reach_ratio": reachRatio,
    "engagement_per_post": engagementPerPost,
    "post_count": postCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "username": username,
  };
}
