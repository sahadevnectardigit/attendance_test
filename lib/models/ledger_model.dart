class LedgerModel {
  Summary? summary;
  List<DetailData>? detailData;

  LedgerModel({this.summary, this.detailData});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
    if (json['detail_data'] != null) {
      detailData = <DetailData>[];
      json['detail_data'].forEach((v) {
        detailData!.add(DetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (detailData != null) {
      data['detail_data'] = detailData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? total;
  int? present;
  int? absent;
  int? leave;
  int? officialVisit;
  int? holiday;
  int? weekend;
  int? lateIn;
  int? earlyOut;

  Summary({
    this.total,
    this.present,
    this.absent,
    this.leave,
    this.officialVisit,
    this.holiday,
    this.weekend,
    this.lateIn,
    this.earlyOut,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    present = json['Present'];
    absent = json['Absent'];
    leave = json['Leave'];
    officialVisit = json['Official Visit'];
    holiday = json['Holiday'];
    weekend = json['Weekend'];
    lateIn = json['LateIn'];
    earlyOut = json['EarlyOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Total'] = total;
    data['Present'] = present;
    data['Absent'] = absent;
    data['Leave'] = leave;
    data['Official Visit'] = officialVisit;
    data['Holiday'] = holiday;
    data['Weekend'] = weekend;
    data['LateIn'] = lateIn;
    data['EarlyOut'] = earlyOut;
    return data;
  }
}

class DetailData {
  String? date;
  String? day;
  String? timeIn;
  String? timeOut;
  String? timeRemarksIn;
  String? timeRemarksOut;
  String? workedHour;
  String? ot;
  String? remarks;

  DetailData({
    this.date,
    this.day,
    this.timeIn,
    this.timeOut,
    this.timeRemarksIn,
    this.timeRemarksOut,
    this.workedHour,
    this.ot,
    this.remarks,
  });

  DetailData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    timeIn = json['time_in'];
    timeOut = json['time_out'];
    timeRemarksIn = json['time_remarks_in'];
    timeRemarksOut = json['time_remarks_out'];
    workedHour = json['worked_hour'];
    ot = json['ot'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['time_in'] = timeIn;
    data['time_out'] = timeOut;
    data['time_remarks_in'] = timeRemarksIn;
    data['time_remarks_out'] = timeRemarksOut;
    data['worked_hour'] = workedHour;
    data['ot'] = ot;
    data['remarks'] = remarks;
    return data;
  }
}
