class UserScoreModel {
  final String name;
  final double score;
  final String? avatarUrl;

  UserScoreModel({
    required this.name,
    required this.score,
    required this.avatarUrl,
  });

  factory UserScoreModel.fromJson(Map<String, dynamic> json) => UserScoreModel(
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
