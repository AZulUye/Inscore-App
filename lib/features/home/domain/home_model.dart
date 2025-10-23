class HomeResponse {
  final bool success;
  final String message;
  final HomeData? data;

  HomeResponse({required this.success, required this.message, this.data});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? HomeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class HomeData {
  final UserInfo user;
  final List<PlatformConnection> platforms;
  final TodayScore today;
  final WeeklyComparison weeklyComparison;
  final Charts charts;

  HomeData({
    required this.user,
    required this.platforms,
    required this.today,
    required this.weeklyComparison,
    required this.charts,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      platforms: (json['platforms'] as List<dynamic>)
          .map((e) => PlatformConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
      today: TodayScore.fromJson(json['today'] as Map<String, dynamic>),
      weeklyComparison: WeeklyComparison.fromJson(
        json['weeklyComparison'] as Map<String, dynamic>,
      ),
      charts: Charts.fromJson(json['charts'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'platforms': platforms.map((e) => e.toJson()).toList(),
      'today': today.toJson(),
      'weeklyComparison': weeklyComparison.toJson(),
      'charts': charts.toJson(),
    };
  }
}

class UserInfo {
  final int id;
  final String name;

  UserInfo({required this.id, required this.name});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class PlatformConnection {
  final String platform;
  final bool connected;
  final String? account;

  PlatformConnection({
    required this.platform,
    required this.connected,
    this.account,
  });

  factory PlatformConnection.fromJson(Map<String, dynamic> json) {
    return PlatformConnection(
      platform: json['platform'] as String,
      connected: json['connected'] as bool,
      account: json['account'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'platform': platform, 'connected': connected, 'account': account};
  }
}

class TodayScore {
  final double score;
  final List<PlatformScore> perPlatform;
  final Rank rank;

  TodayScore({
    required this.score,
    required this.perPlatform,
    required this.rank,
  });

  factory TodayScore.fromJson(Map<String, dynamic> json) {
    return TodayScore(
      score: (json['score'] as num).toDouble(),
      perPlatform: (json['perPlatform'] as List<dynamic>)
          .map((e) => PlatformScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      rank: Rank.fromJson(json['rank'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'perPlatform': perPlatform.map((e) => e.toJson()).toList(),
      'rank': rank.toJson(),
    };
  }
}

class PlatformScore {
  final String platform;
  final double score;

  PlatformScore({required this.platform, required this.score});

  factory PlatformScore.fromJson(Map<String, dynamic> json) {
    return PlatformScore(
      platform: json['platform'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'platform': platform, 'score': score};
  }
}

class Rank {
  final int position;
  final int total;

  Rank({required this.position, required this.total});

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(position: json['position'] as int, total: json['total'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'position': position, 'total': total};
  }
}

class WeeklyComparison {
  final double lastWeekAvgScore;
  final double thisWeekAvgScore;
  final double deltaPercent;

  WeeklyComparison({
    required this.lastWeekAvgScore,
    required this.thisWeekAvgScore,
    required this.deltaPercent,
  });

  factory WeeklyComparison.fromJson(Map<String, dynamic> json) {
    return WeeklyComparison(
      lastWeekAvgScore: (json['lastWeekAvgScore'] as num).toDouble(),
      thisWeekAvgScore: (json['thisWeekAvgScore'] as num).toDouble(),
      deltaPercent: (json['deltaPercent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastWeekAvgScore': lastWeekAvgScore,
      'thisWeekAvgScore': thisWeekAvgScore,
      'deltaPercent': deltaPercent,
    };
  }
}

class Charts {
  final List<DailyScoreSeries> dailyScoreSeries;

  Charts({required this.dailyScoreSeries});

  factory Charts.fromJson(Map<String, dynamic> json) {
    return Charts(
      dailyScoreSeries: (json['dailyScoreSeries'] as List<dynamic>)
          .map((e) => DailyScoreSeries.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyScoreSeries': dailyScoreSeries.map((e) => e.toJson()).toList(),
    };
  }
}

class DailyScoreSeries {
  final String date;
  final double value;

  DailyScoreSeries({required this.date, required this.value});

  factory DailyScoreSeries.fromJson(Map<String, dynamic> json) {
    return DailyScoreSeries(
      date: json['date'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'value': value};
  }
}
