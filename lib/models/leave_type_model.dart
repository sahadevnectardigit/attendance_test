class LeaveTypeModel {
  final int id;
  final String name;
  final String shortName;
  final int days;
  final String gender;

  LeaveTypeModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.days,
    required this.gender,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      days: json['days'] as int,
      gender: json['gender'] as String,
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
