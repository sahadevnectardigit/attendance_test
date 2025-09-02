class OfficialVisitModel {
  final int id;
  final String name;
  final String shortName;

  OfficialVisitModel({
    required this.id,
    required this.name,
    required this.shortName,
  });

  factory OfficialVisitModel.fromJson(Map<String, dynamic> json) {
    return OfficialVisitModel(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
    };
  }
}
