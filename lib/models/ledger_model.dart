class LedgerModel {
  final SummaryData? summaryData;
  final List<DetailData>? detailData;

  LedgerModel({this.summaryData, this.detailData});

  factory LedgerModel.fromJson(Map<String, dynamic> json) {
    return LedgerModel(
      summaryData: SummaryData.fromJson(json['summary']),
      detailData: (json['detail_data'] as List)
          .map((detail) => DetailData.fromJson(detail))
          .toList(),
    );
  }
}

class SummaryData {
  final int total;
  final int present;
  final int absent;
  final int leave;
  final int officialVisit;
  final int holiday;
  final int weekend;
  final int lateIn;
  final int earlyOut;

  SummaryData({
    required this.total,
    required this.present,
    required this.absent,
    required this.leave,
    required this.officialVisit,
    required this.holiday,
    required this.weekend,
    required this.lateIn,
    required this.earlyOut,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      total: json['Total'] ?? 0,
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      leave: json['Leave'] ?? 0,
      officialVisit: json['Official Visit'] ?? 0,
      holiday: json['Holiday'] ?? 0,
      weekend: json['Weekend'] ?? 0,
      lateIn: json['LateIn'] ?? 0,
      earlyOut: json['EarlyOut'] ?? 0,
    );
  }
}

class DetailData {
  final String date;
  final String day;
  final String timeIn;
  final String timeOut;
  final String timeRemarksIn;
  final String timeRemarksOut;
  final String workedHour;
  final String ot;
  final String remarks;

  DetailData({
    required this.date,
    required this.day,
    required this.timeIn,
    required this.timeOut,
    required this.timeRemarksIn,
    required this.timeRemarksOut,
    required this.workedHour,
    required this.ot,
    required this.remarks,
  });

  factory DetailData.fromJson(Map<String, dynamic> json) {
    return DetailData(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      timeIn: json['time_in'] ?? '',
      timeOut: json['time_out'] ?? '',
      timeRemarksIn: json['time_remarks_in'] ?? '',
      timeRemarksOut: json['time_remarks_out'] ?? '',
      workedHour: json['worked_hour'] ?? '',
      ot: json['ot'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}

