class LedgerModel {
  final String? person;
  final SummaryData? summaryData;
  final List<DetailData>? detailData;
  final bool enableNepaliDate;

  LedgerModel({
    this.person,
    this.summaryData,
    this.detailData,
    this.enableNepaliDate = false,
  });

  factory LedgerModel.fromJson(Map<String, dynamic> json) {
    return LedgerModel(
      person: json['person'],
      summaryData: json['summary'] != null 
          ? SummaryData.fromJson(json['summary']) 
          : null,
      detailData: json['detail_data'] != null
          ? (json['detail_data'] as List)
              .map((detail) => DetailData.fromJson(detail))
              .toList()
          : null,
      enableNepaliDate: json['enable_nepali_date'] ?? false,
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
  final int specialDays;
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
    required this.specialDays,
    required this.lateIn,
    required this.earlyOut,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      total: json['Total'] ?? 0,
      present: json['Present'] ?? 0,
      absent: json['Absent'] ?? 0,
      leave: json['Leave'] ?? 0,
      officialVisit: json['Official_Visit'] ?? 0,
      holiday: json['Holiday'] ?? 0,
      weekend: json['Weekend'] ?? 0,
      specialDays: json['Special_Days'] ?? 0,
      lateIn: json['LateIn'] ?? 0,
      earlyOut: json['EarlyOut'] ?? 0,
    );
  }
}

class DetailData {
  final String date;
  final String day;
  final List<ShiftData> shifts;
  final bool hasMultipleShifts;
  final bool dayHasLeave;
  final bool dayHasOv;
  final bool dayHasHoliday;
  final bool dayIsWeekend;
  final List<String> companyWeekends;
  final String overallStatus;

  DetailData({
    required this.date,
    required this.day,
    required this.shifts,
    required this.hasMultipleShifts,
    required this.dayHasLeave,
    required this.dayHasOv,
    required this.dayHasHoliday,
    required this.dayIsWeekend,
    required this.companyWeekends,
    required this.overallStatus,
  });

  factory DetailData.fromJson(Map<String, dynamic> json) {
    return DetailData(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      shifts: json['shifts'] != null
          ? (json['shifts'] as List)
              .map((shift) => ShiftData.fromJson(shift))
              .toList()
          : [],
      hasMultipleShifts: json['has_multiple_shifts'] ?? false,
      dayHasLeave: json['day_has_leave'] ?? false,
      dayHasOv: json['day_has_ov'] ?? false,
      dayHasHoliday: json['day_has_holiday'] ?? false,
      dayIsWeekend: json['day_is_weekend'] ?? false,
      companyWeekends: json['company_weekends'] != null
          ? List<String>.from(json['company_weekends'])
          : [],
      overallStatus: json['overall_status'] ?? '',
    );
  }

  // Helper getter for backward compatibility
  String get timeIn => shifts.isNotEmpty ? shifts.first.timeIn : '';
  String get timeOut => shifts.isNotEmpty ? shifts.first.timeOut : '';
  String get timeRemarksIn => shifts.isNotEmpty ? shifts.first.timeRemarksIn : '';
  String get timeRemarksOut => shifts.isNotEmpty ? shifts.first.timeRemarksOut : '';
  String get workedHour => shifts.isNotEmpty ? shifts.first.workedHour : '';

  // Helper method to extract day number from date (handles both formats)
  int? get dayNumber {
    try {
      // Try hyphen separator first (2025-12-01)
      if (date.contains('-')) {
        final parts = date.split('-');
        if (parts.length == 3) {
          return int.tryParse(parts[2]);
        }
      }
      // Try slash separator (2082/06/01)
      else if (date.contains('/')) {
        final parts = date.split('/');
        if (parts.length == 3) {
          return int.tryParse(parts[2]);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

class ShiftData {
  final String shiftName;
  final String shiftType;
  final String shiftSource;
  final String fromTime;
  final String toTime;
  final String timeIn;
  final String timeOut;
  final String timeRemarksIn;
  final String timeRemarksOut;
  final String workedHour;
  final bool isSpecial;
  final int shiftIndex;
  final String status;

  ShiftData({
    required this.shiftName,
    required this.shiftType,
    required this.shiftSource,
    required this.fromTime,
    required this.toTime,
    required this.timeIn,
    required this.timeOut,
    required this.timeRemarksIn,
    required this.timeRemarksOut,
    required this.workedHour,
    required this.isSpecial,
    required this.shiftIndex,
    required this.status,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) {
    return ShiftData(
      shiftName: json['shift_name'] ?? '',
      shiftType: json['shift_type'] ?? '',
      shiftSource: json['shift_source'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
      timeIn: json['time_in'] ?? '',
      timeOut: json['time_out'] ?? '',
      timeRemarksIn: json['time_remarks_in'] ?? '',
      timeRemarksOut: json['time_remarks_out'] ?? '',
      workedHour: json['worked_hour'] ?? '',
      isSpecial: json['is_special'] ?? false,
      shiftIndex: json['shift_index'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

// class LedgerModel {
//   final String? person;
//   final SummaryData? summaryData;
//   final List<DetailData>? detailData;
//   final bool enableNepaliDate;

//   LedgerModel({
//     this.person,
//     this.summaryData,
//     this.detailData,
//     this.enableNepaliDate = false,
//   });

//   factory LedgerModel.fromJson(Map<String, dynamic> json) {
//     return LedgerModel(
//       person: json['person'],
//       summaryData: json['summary'] != null 
//           ? SummaryData.fromJson(json['summary']) 
//           : null,
//       detailData: json['detail_data'] != null
//           ? (json['detail_data'] as List)
//               .map((detail) => DetailData.fromJson(detail))
//               .toList()
//           : null,
//       enableNepaliDate: json['enable_nepali_date'] ?? false,
//     );
//   }
// }

// class SummaryData {
//   final int total;
//   final int present;
//   final int absent;
//   final int leave;
//   final int officialVisit;
//   final int holiday;
//   final int weekend;
//   final int specialDays;
//   final int lateIn;
//   final int earlyOut;

//   SummaryData({
//     required this.total,
//     required this.present,
//     required this.absent,
//     required this.leave,
//     required this.officialVisit,
//     required this.holiday,
//     required this.weekend,
//     required this.specialDays,
//     required this.lateIn,
//     required this.earlyOut,
//   });

//   factory SummaryData.fromJson(Map<String, dynamic> json) {
//     return SummaryData(
//       total: json['Total'] ?? 0,
//       present: json['Present'] ?? 0,
//       absent: json['Absent'] ?? 0,
//       leave: json['Leave'] ?? 0,
//       officialVisit: json['Official_Visit'] ?? 0,
//       holiday: json['Holiday'] ?? 0,
//       weekend: json['Weekend'] ?? 0,
//       specialDays: json['Special_Days'] ?? 0,
//       lateIn: json['LateIn'] ?? 0,
//       earlyOut: json['EarlyOut'] ?? 0,
//     );
//   }
// }

// class DetailData {
//   final String date;
//   final String day;
//   final List<ShiftData> shifts;
//   final bool hasMultipleShifts;
//   final bool dayHasLeave;
//   final bool dayHasOv;
//   final bool dayHasHoliday;
//   final bool dayIsWeekend;
//   final List<String> companyWeekends;
//   final String overallStatus;

//   DetailData({
//     required this.date,
//     required this.day,
//     required this.shifts,
//     required this.hasMultipleShifts,
//     required this.dayHasLeave,
//     required this.dayHasOv,
//     required this.dayHasHoliday,
//     required this.dayIsWeekend,
//     required this.companyWeekends,
//     required this.overallStatus,
//   });

//   factory DetailData.fromJson(Map<String, dynamic> json) {
//     return DetailData(
//       date: json['date'] ?? '',
//       day: json['day'] ?? '',
//       shifts: json['shifts'] != null
//           ? (json['shifts'] as List)
//               .map((shift) => ShiftData.fromJson(shift))
//               .toList()
//           : [],
//       hasMultipleShifts: json['has_multiple_shifts'] ?? false,
//       dayHasLeave: json['day_has_leave'] ?? false,
//       dayHasOv: json['day_has_ov'] ?? false,
//       dayHasHoliday: json['day_has_holiday'] ?? false,
//       dayIsWeekend: json['day_is_weekend'] ?? false,
//       companyWeekends: json['company_weekends'] != null
//           ? List<String>.from(json['company_weekends'])
//           : [],
//       overallStatus: json['overall_status'] ?? '',
//     );
//   }

//   // Helper getter for backward compatibility
//   String get timeIn => shifts.isNotEmpty ? shifts.first.timeIn : '';
//   String get timeOut => shifts.isNotEmpty ? shifts.first.timeOut : '';
//   String get timeRemarksIn => shifts.isNotEmpty ? shifts.first.timeRemarksIn : '';
//   String get timeRemarksOut => shifts.isNotEmpty ? shifts.first.timeRemarksOut : '';
//   String get workedHour => shifts.isNotEmpty ? shifts.first.workedHour : '';
// }

// class ShiftData {
//   final String shiftName;
//   final String shiftType;
//   final String shiftSource;
//   final String fromTime;
//   final String toTime;
//   final String timeIn;
//   final String timeOut;
//   final String timeRemarksIn;
//   final String timeRemarksOut;
//   final String workedHour;
//   final bool isSpecial;
//   final int shiftIndex;
//   final String status;

//   ShiftData({
//     required this.shiftName,
//     required this.shiftType,
//     required this.shiftSource,
//     required this.fromTime,
//     required this.toTime,
//     required this.timeIn,
//     required this.timeOut,
//     required this.timeRemarksIn,
//     required this.timeRemarksOut,
//     required this.workedHour,
//     required this.isSpecial,
//     required this.shiftIndex,
//     required this.status,
//   });

//   factory ShiftData.fromJson(Map<String, dynamic> json) {
//     return ShiftData(
//       shiftName: json['shift_name'] ?? '',
//       shiftType: json['shift_type'] ?? '',
//       shiftSource: json['shift_source'] ?? '',
//       fromTime: json['from_time'] ?? '',
//       toTime: json['to_time'] ?? '',
//       timeIn: json['time_in'] ?? '',
//       timeOut: json['time_out'] ?? '',
//       timeRemarksIn: json['time_remarks_in'] ?? '',
//       timeRemarksOut: json['time_remarks_out'] ?? '',
//       workedHour: json['worked_hour'] ?? '',
//       isSpecial: json['is_special'] ?? false,
//       shiftIndex: json['shift_index'] ?? 0,
//       status: json['status'] ?? '',
//     );
//   }
// }

// // class LedgerModel {
// //   final SummaryData? summaryData;
// //   final List<DetailData>? detailData;

// //   LedgerModel({this.summaryData, this.detailData});

// //   factory LedgerModel.fromJson(Map<String, dynamic> json) {
// //     return LedgerModel(
// //       summaryData: SummaryData.fromJson(json['summary']),
// //       detailData: (json['detail_data'] as List)
// //           .map((detail) => DetailData.fromJson(detail))
// //           .toList(),
// //     );
// //   }
// // }

// // class SummaryData {
// //   final int total;
// //   final int present;
// //   final int absent;
// //   final int leave;
// //   final int officialVisit;
// //   final int holiday;
// //   final int weekend;
// //   final int lateIn;
// //   final int earlyOut;

// //   SummaryData({
// //     required this.total,
// //     required this.present,
// //     required this.absent,
// //     required this.leave,
// //     required this.officialVisit,
// //     required this.holiday,
// //     required this.weekend,
// //     required this.lateIn,
// //     required this.earlyOut,
// //   });

// //   factory SummaryData.fromJson(Map<String, dynamic> json) {
// //     return SummaryData(
// //       total: json['Total'] ?? 0,
// //       present: json['Present'] ?? 0,
// //       absent: json['Absent'] ?? 0,
// //       leave: json['Leave'] ?? 0,
// //       officialVisit: json['Official Visit'] ?? 0,
// //       holiday: json['Holiday'] ?? 0,
// //       weekend: json['Weekend'] ?? 0,
// //       lateIn: json['LateIn'] ?? 0,
// //       earlyOut: json['EarlyOut'] ?? 0,
// //     );
// //   }
// // }

// // class DetailData {
// //   final String date;
// //   final String day;
// //   final String timeIn;
// //   final String timeOut;
// //   final String timeRemarksIn;
// //   final String timeRemarksOut;
// //   final String workedHour;
// //   final String ot;
// //   final String remarks;

// //   DetailData({
// //     required this.date,
// //     required this.day,
// //     required this.timeIn,
// //     required this.timeOut,
// //     required this.timeRemarksIn,
// //     required this.timeRemarksOut,
// //     required this.workedHour,
// //     required this.ot,
// //     required this.remarks,
// //   });

// //   factory DetailData.fromJson(Map<String, dynamic> json) {
// //     return DetailData(
// //       date: json['date'] ?? '',
// //       day: json['day'] ?? '',
// //       timeIn: json['time_in'] ?? '',
// //       timeOut: json['time_out'] ?? '',
// //       timeRemarksIn: json['time_remarks_in'] ?? '',
// //       timeRemarksOut: json['time_remarks_out'] ?? '',
// //       workedHour: json['worked_hour'] ?? '',
// //       ot: json['ot'] ?? '',
// //       remarks: json['remarks'] ?? '',
// //     );
// //   }
// // }

