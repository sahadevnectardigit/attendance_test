class LateInOutAppListModel {
  final int? id;
  final String? lateInOut;
  final int? nameId;
  final UserInfo? name;
  final String? dateEn;
  final String? dateNp;
  final int? approvedBy;
  final int? recommendedBy;
  final bool? approved;
  final String? approvedDate;
  final String? recommendedDate;
  final String? remarks;
  final String? appliedDate;
  final bool? viewed;
  final String? currentStatus;

  LateInOutAppListModel({
    this.id,
    this.lateInOut,
    this.nameId,
    this.name,
    this.dateEn,
    this.dateNp,
    this.approvedBy,
    this.recommendedBy,
    this.approved,
    this.approvedDate,
    this.recommendedDate,
    this.remarks,
    this.appliedDate,
    this.viewed,
    this.currentStatus,
  });

  factory LateInOutAppListModel.fromJson(Map<String, dynamic> json) {
    return LateInOutAppListModel(
      id: json['id'],
      lateInOut: json['late_in_out'],
      nameId: json['name_id'],
      name: json['name'] != null ? UserInfo.fromJson(json['name']) : null,
      dateEn: json['date_en'],
      dateNp: json['date_np'],
      approvedBy: json['approved_by'],
      recommendedBy: json['recommended_by'],
      approved: json['approved'],
      approvedDate: json['approved_date'],
      recommendedDate: json['recommended_date'],
      remarks: json['remarks'],
      appliedDate: json['applied_date'],
      viewed: json['viewed'],
      currentStatus: json['current_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'late_in_out': lateInOut,
      'name_id': nameId,
      'name': name?.toJson(),
      'date_en': dateEn,
      'date_np': dateNp,
      'approved_by': approvedBy,
      'recommended_by': recommendedBy,
      'approved': approved,
      'approved_date': approvedDate,
      'recommended_date': recommendedDate,
      'remarks': remarks,
      'applied_date': appliedDate,
      'viewed': viewed,
      'current_status': currentStatus,
    };
  }

  static List<LateInOutAppListModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => LateInOutAppListModel.fromJson(e)).toList();
  }
}

class UserInfo {
  final int? id;
  final String? username;
  final String? email;

  UserInfo({
    this.id,
    this.username,
    this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
