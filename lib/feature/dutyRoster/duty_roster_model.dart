class DutyRosterResponse {
  final int year;
  final int month;
  final bool nepaliEnabled;
  final RosterData? rosterData;

  DutyRosterResponse({
    required this.year,
    required this.month,
    required this.nepaliEnabled,
    this.rosterData,
  });

  factory DutyRosterResponse.fromJson(Map<String, dynamic> json) {
    return DutyRosterResponse(
      year: json['year'],
      month: json['month'],
      nepaliEnabled: json['nepali_enabled'],
      rosterData: json['roster_data'] != null
          ? RosterData.fromJson(json['roster_data'])
          : null,
    );
  }
}

class Department {
  final String? name;
  Department({this.name});
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(name: json['name']);
  }
}

class RosterData {
  final int? person;
  final String? personName; // Added from response
  final Branch? branch;
  // final Department? department;
  final Designation? designation;
  final Map<String, DayData>? days; // Changed from List<Shift> to DayData

  RosterData({
    this.person,
    this.personName,
    this.branch,
    // this.department,
    this.designation,
    this.days,
  });

  factory RosterData.fromJson(Map<String, dynamic> json) {
    Map<String, DayData>? parsedDays;

    if (json['days'] != null) {
      parsedDays = {};
      (json['days'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null) {
          parsedDays![key] = DayData.fromJson(value);
        }
      });
    }

    return RosterData(
      person: json['person'],
      personName: json['person_name'], // Added
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      // department: json['department'] != null
      //     ? Department.fromJson(json['name'])
      //     : null,

      designation: json['designation'] != null
          ? Designation.fromJson(json['designation'])
          : null,
      days: parsedDays,
    );
  }
}

class DayData {
  final List<RosterEntry>? rosterEntries; // Changed from List<Shift>

  DayData({this.rosterEntries});

  factory DayData.fromJson(Map<String, dynamic> json) {
    List<RosterEntry>? entries;

    if (json['roster_entries'] != null) {
      entries = (json['roster_entries'] as List)
          .map((e) => RosterEntry.fromJson(e))
          .toList();
    }

    return DayData(rosterEntries: entries);
  }
}

class RosterEntry {
  // Renamed from Shift to RosterEntry
  final int? id;
  final String? shift;
  final bool? nightOff;
  final bool? dayOff;
  final bool? exchange;
  final String? weekdayShort; // Added from response
  final String? weekdayFull; // Added from response

  RosterEntry({
    this.id,
    this.shift,
    this.nightOff,
    this.dayOff,
    this.exchange,
    this.weekdayShort,
    this.weekdayFull,
  });

  factory RosterEntry.fromJson(Map<String, dynamic> json) {
    return RosterEntry(
      id: json['id'],
      shift: json['shift'],
      nightOff: json['night_off'],
      dayOff: json['day_off'],
      exchange: json['exchange'],
      weekdayShort: json['weekday_short'],
      weekdayFull: json['weekday_full'],
    );
  }
}

class Branch {
  final String? name;

  Branch({this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(name: json['name']);
  }
}

class Designation {
  final int? id;
  final String? name;

  Designation({this.id, this.name});

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(id: json['id'], name: json['name']);
  }
}
