class DutyRosterResponse {
  final int year;
  final int month;
  final bool nepaliEnabled;
  final RosterData? rosterData; // Made nullable

  DutyRosterResponse({
    required this.year,
    required this.month,
    required this.nepaliEnabled,
    this.rosterData, // Made nullable
  });

  factory DutyRosterResponse.fromJson(Map<String, dynamic> json) {
    return DutyRosterResponse(
      year: json['year'],
      month: json['month'],
      nepaliEnabled: json['nepali_enabled'],
      rosterData: json['roster_data'] != null
          ? RosterData.fromJson(json['roster_data'])
          : null, // Handle null case
    );
  }
}

class RosterData {
  final int? person; // Made nullable
  final Branch? branch; // Made nullable
  final String? department; // Already nullable
  final Designation? designation; // Made nullable
  final Map<String, List<Shift>>? days; // Made nullable

  RosterData({
    this.person,
    this.branch,
    this.department,
    this.designation,
    this.days,
  });

  factory RosterData.fromJson(Map<String, dynamic> json) {
    Map<String, List<Shift>>? parsedDays;

    if (json['days'] != null) {
      parsedDays = {};
      (json['days'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null) {
          parsedDays![key] = (value as List)
              .map((e) => Shift.fromJson(e))
              .toList();
        }
      });
    }

    return RosterData(
      person: json['person'],
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      department: json['department'],
      designation: json['designation'] != null
          ? Designation.fromJson(json['designation'])
          : null,
      days: parsedDays,
    );
  }
}

class Shift {
  final int? id; // Made nullable
  final String? shift; // Made nullable
  final bool? nightOff; // Made nullable
  final bool? dayOff; // Made nullable
  final bool? exchange; // Made nullable

  Shift({this.id, this.shift, this.nightOff, this.dayOff, this.exchange});

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      shift: json['shift'] ?? 'No Shift',
      nightOff: json['night_off'],
      dayOff: json['day_off'],
      exchange: json['exchange'],
    );
  }
}

class Branch {
  final String? name; // Made nullable

  Branch({this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(name: json['name']);
  }
}

class Designation {
  final int? id; // Made nullable
  final String? name; // Made nullable

  Designation({this.id, this.name});

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(id: json['id'], name: json['name']);
  }
}
