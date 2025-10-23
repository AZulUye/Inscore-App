import 'dart:convert';

class ResponseScore {
  bool success;
  String message;
  Data data;

  ResponseScore({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResponseScore.fromRawJson(String str) =>
      ResponseScore.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseScore.fromJson(Map<String, dynamic> json) => ResponseScore(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int businessId;
  DateTime date;
  double instagramScore;
  double facebookScore;
  double finalScore;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.businessId,
    required this.date,
    required this.instagramScore,
    required this.facebookScore,
    required this.finalScore,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessId: json["business_id"],
    date: DateTime.parse(json["date"]),
    instagramScore: (json["instagram_score"] ?? 0).toDouble(),
    facebookScore: (json["facebook_score"] ?? 0).toDouble(),
    finalScore: (json["final_score"] ?? 0).toDouble(),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "business_id": businessId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "instagram_score": instagramScore,
    "facebook_score": facebookScore,
    "final_score": finalScore,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
