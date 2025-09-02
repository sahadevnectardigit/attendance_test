class ApproveRecommendModel {
  List<Person> approvedBy;
  List<Person> recommendedBy;

  ApproveRecommendModel({required this.approvedBy, required this.recommendedBy});

  factory ApproveRecommendModel.fromJson(Map<String, dynamic> json) {
    return ApproveRecommendModel(
      approvedBy: (json['approved_by'] as List<dynamic>)
          .map((e) => Person.fromJson(e))
          .toList(),
      recommendedBy: (json['recommended_by'] as List<dynamic>)
          .map((e) => Person.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approved_by': approvedBy.map((e) => e.toJson()).toList(),
      'recommended_by': recommendedBy.map((e) => e.toJson()).toList(),
    };
  }
}

class Person {
  final int id;
  final String firstName;
  final String? lastName;
  final String? email;

  Person({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
