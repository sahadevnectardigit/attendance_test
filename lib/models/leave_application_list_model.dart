class LeaveApplicationListModel {
  final int? id;
  final LeaveType? name;
  final int? person;
  final String? fromDateEn;
  final String? fromDateNp;
  final String? toDateEn;
  final String? toDateNp;
  final int? approvedBy;
  final int? recommendedBy;
  final bool? approved;
  final String? approvedDate;
  final String? recommendedDate;
  final String? days;
  final bool? halfDay;
  final String? remarks;
  final String? appliedDate;
  final String? paidDays;
  final String? unpaidDays;
  final bool? viewed;
  final String? currentStatus;

  LeaveApplicationListModel({
    this.id,
    this.name,
    this.person,
    this.fromDateEn,
    this.fromDateNp,
    this.toDateEn,
    this.toDateNp,
    this.approvedBy,
    this.recommendedBy,
    this.approved,
    this.approvedDate,
    this.recommendedDate,
    this.days,
    this.halfDay,
    this.remarks,
    this.appliedDate,
    this.paidDays,
    this.unpaidDays,
    this.viewed,
    this.currentStatus,
  });

  factory LeaveApplicationListModel.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationListModel(
      id: json['id'],
      name: json['name'] != null ? LeaveType.fromJson(json['name']) : null,
      person: json['person'],
      fromDateEn: json['from_date_en'],
      fromDateNp: json['from_date_np'],
      toDateEn: json['to_date_en'],
      toDateNp: json['to_date_np'],
      approvedBy: json['approved_by'],
      recommendedBy: json['recommended_by'],
      approved: json['approved'],
      approvedDate: json['approved_date'],
      recommendedDate: json['recommended_date'],
      days: json['days'],
      halfDay: json['half_day'],
      remarks: json['remarks'],
      appliedDate: json['applied_date'],
      paidDays: json['paid_days'],
      unpaidDays: json['unpaid_days'],
      viewed: json['viewed'],
      currentStatus: json['current_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name?.toJson(),
      'person': person,
      'from_date_en': fromDateEn,
      'from_date_np': fromDateNp,
      'to_date_en': toDateEn,
      'to_date_np': toDateNp,
      'approved_by': approvedBy,
      'recommended_by': recommendedBy,
      'approved': approved,
      'approved_date': approvedDate,
      'recommended_date': recommendedDate,
      'days': days,
      'half_day': halfDay,
      'remarks': remarks,
      'applied_date': appliedDate,
      'paid_days': paidDays,
      'unpaid_days': unpaidDays,
      'viewed': viewed,
      'current_status': currentStatus,
    };
  }

  static List<LeaveApplicationListModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => LeaveApplicationListModel.fromJson(e)).toList();
  }
}

class LeaveType {
  final int? id;
  final String? name;
  final String? shortName;
  final int? days;
  final String? gender;

  LeaveType({
    this.id,
    this.name,
    this.shortName,
    this.days,
    this.gender,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
      days: json['days'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'days': days,
      'gender': gender,
    };
  }
}
