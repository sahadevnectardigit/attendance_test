class OfficialApplicationListModel {
  final int id;
  final String name;
  final String shortName;
  final String fromDateEn;
  final String toDateEn;
  final String appliedDate;
  final String place;
  final String days;
  final bool approved;
  final String? approvedDate;
  final String currentStatus;

  OfficialApplicationListModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.fromDateEn,
    required this.toDateEn,
    required this.appliedDate,
    required this.place,
    required this.days,
    required this.approved,
    this.approvedDate,
    required this.currentStatus,
  });

  factory OfficialApplicationListModel.fromJson(Map<String, dynamic> json) {
    return OfficialApplicationListModel(
      id: json['id'],
      name: json['name']['name'],
      shortName: json['name']['short_name'],
      fromDateEn: json['from_date_en'],
      toDateEn: json['to_date_en'],
      appliedDate: json['applied_date'],
      place: json['place'],
      days: json['days'],
      approved: json['approved'],
      approvedDate: json['approved_date'],
      currentStatus: json['current_status'],
    );
  }

  static List<OfficialApplicationListModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => OfficialApplicationListModel.fromJson(e)).toList();
  }
}
