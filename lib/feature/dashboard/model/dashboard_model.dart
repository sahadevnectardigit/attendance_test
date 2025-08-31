class DashBoardModel {
  DailyStats? dailyStats;
  DailyStats? monthlyStats;
  String? nepaliMonth;

  DashBoardModel({this.dailyStats, this.monthlyStats, this.nepaliMonth});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    dailyStats = json['daily_stats'] != null
        ? DailyStats.fromJson(json['daily_stats'])
        : null;
    monthlyStats = json['monthly_stats'] != null
        ? DailyStats.fromJson(json['monthly_stats'])
        : null;
    nepaliMonth = json['nepali_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyStats != null) {
      data['daily_stats'] = dailyStats!.toJson();
    }
    if (monthlyStats != null) {
      data['monthly_stats'] = monthlyStats!.toJson();
    }
    data['nepali_month'] = nepaliMonth;
    return data;
  }
}

class DailyStats {
  int? present;
  int? absent;
  int? lateIn;
  int? earlyOut;
  int? holiday;
  int? approvedLeave;
  int? weekend;
  int? officialVisit;

  DailyStats({
    this.present,
    this.absent,
    this.lateIn,
    this.earlyOut,
    this.holiday,
    this.approvedLeave,
    this.weekend,
    this.officialVisit,
  });

  DailyStats.fromJson(Map<String, dynamic> json) {
    present = json['Present'];
    absent = json['Absent'];
    lateIn = json['LateIn'];
    earlyOut = json['EarlyOut'];
    holiday = json['Holiday'];
    approvedLeave = json['Approved Leave'];
    weekend = json['Weekend'];
    officialVisit = json['Official Visit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Present'] = present;
    data['Absent'] = absent;
    data['LateIn'] = lateIn;
    data['EarlyOut'] = earlyOut;
    data['Holiday'] = holiday;
    data['Approved Leave'] = approvedLeave;
    data['Weekend'] = weekend;
    data['Official Visit'] = officialVisit;
    return data;
  }
}
