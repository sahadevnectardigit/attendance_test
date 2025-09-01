class DashBoardModel {
  final DailyStats dailyStats;
  final MonthlyStats? monthlyStats;
  final String nepaliMonth;

  DashBoardModel({
    required this.dailyStats,
    this.monthlyStats,
    required this.nepaliMonth,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      dailyStats: DailyStats.fromJson(json['daily_stats']),
      monthlyStats: MonthlyStats.fromJson(json['monthly_stats']),
      nepaliMonth: json['nepali_month'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_stats': dailyStats.toJson(),
      'monthly_stats': monthlyStats?.toJson(),
      'nepali_month': nepaliMonth,
    };
  }
}

class DailyStats {
  final int present;
  final int absent;
  final int lateIn;
  final int earlyOut;
  final int holiday;
  final int approvedLeave;
  final int weekend;
  final int officialVisit;

  DailyStats({
    required this.present,
    required this.absent,
    required this.lateIn,
    required this.earlyOut,
    required this.holiday,
    required this.approvedLeave,
    required this.weekend,
    required this.officialVisit,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      lateIn: json['LateIn'] ?? 0,
      earlyOut: json['EarlyOut'] ?? 0,
      holiday: json['Holiday'] ?? 0,
      approvedLeave: json['Approved Leave'] ?? 0,
      weekend: json['Weekend'] ?? 0,
      officialVisit: json['Official Visit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Present': present,
      'Absent': absent,
      'LateIn': lateIn,
      'EarlyOut': earlyOut,
      'Holiday': holiday,
      'Approved Leave': approvedLeave,
      'Weekend': weekend,
      'Official Visit': officialVisit,
    };
  }

  /// Convert to map for chart usage
  Map<String, double> toChartData() {
    return {
      'Present': present.toDouble(),
      'Absent': absent.toDouble(),
      'LateIn': lateIn.toDouble(),
      'EarlyOut': earlyOut.toDouble(),
      'Holiday': holiday.toDouble(),
      'Approved Leave': approvedLeave.toDouble(),
      'Weekend': weekend.toDouble(),
      'Official Visit': officialVisit.toDouble(),
    };
  }
}

class MonthlyStats extends DailyStats {
  MonthlyStats({
    required super.present,
    required super.absent,
    required super.lateIn,
    required super.earlyOut,
    required super.holiday,
    required super.approvedLeave,
    required super.weekend,
    required super.officialVisit,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      lateIn: json['LateIn'] ?? 0,
      earlyOut: json['EarlyOut'] ?? 0,
      holiday: json['Holiday'] ?? 0,
      approvedLeave: json['Approved Leave'] ?? 0,
      weekend: json['Weekend'] ?? 0,
      officialVisit: json['Official Visit'] ?? 0,
    );
  }
}
