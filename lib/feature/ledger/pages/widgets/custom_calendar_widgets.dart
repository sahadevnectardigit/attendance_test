import 'dart:developer';

import 'package:attendance/feature/ledger/pages/attendance_day_detail_page.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/l10n/app_localizations.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class CustomCalendarWidget extends StatelessWidget {
  final int year;
  final int month;
  final LedgerProvider ledgerProvider;
  final List<DetailData> detailData;
  final SummaryData? summaryData;

  const CustomCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.ledgerProvider,
    this.detailData = const [],
    this.summaryData,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Print what data we have
    print('Calendar Widget - Year: $year, Month: $month');
    print('DetailData count: ${detailData.length}');
    if (detailData.isNotEmpty) {
      print('Sample dates: ${detailData.take(3).map((d) => d.date).toList()}');
    }

    // Create a map for quick lookup: day number -> DetailData
    Map<int, DetailData> dayDataMap = {};
    for (var detail in detailData) {
      try {
        final parts = detail.date.split('-');
        if (parts.length == 3) {
          final day = int.tryParse(parts[2]);
          if (day != null) {
            dayDataMap[day] = detail;
          }
        }
      } catch (e) {
        print('Error parsing date: ${detail.date}');
      }
    }

    print('DayDataMap keys: ${dayDataMap.keys.toList()}');

    // Determine the maximum day in the month from the API data
    int maxDay = dayDataMap.keys.isEmpty
        ? 32
        : dayDataMap.keys.reduce((a, b) => a > b ? a : b);

    // Find the weekday of the first day of the month
    int firstWeekday = 7; // Default to Sunday if not found
    if (dayDataMap.containsKey(1)) {
      firstWeekday = _getWeekdayNumber(dayDataMap[1]!.day);
    }

    // Calculate total cells needed (including empty cells at the beginning)
    int totalCells = maxDay + firstWeekday - 1;
    int rows = (totalCells / 7).ceil();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month and year header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Text(
              "${_getNepaliMonthName(month)} $year",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Weekday headers
          Row(
            children:
                [
                      AppLocalizations.of(context)!.sun,
                      AppLocalizations.of(context)!.mon,
                      AppLocalizations.of(context)!.tue,
                      AppLocalizations.of(context)!.wed,
                      AppLocalizations.of(context)!.thu,
                      AppLocalizations.of(context)!.fri,
                      AppLocalizations.of(context)!.sat,
                    ]
                    .map(
                      (day) => Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          Divider(height: 1),

          // Calendar days
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: rows,
              itemBuilder: (context, rowIndex) {
                return Row(
                  children: List.generate(7, (columnIndex) {
                    int dayNumber =
                        (rowIndex * 7) + columnIndex - firstWeekday + 2;

                    if (dayNumber < 1 || dayNumber > maxDay) {
                      // Empty cell for days outside the month
                      return Expanded(child: Container());
                    }

                    // Get detail data for this day from the map
                    DetailData? dayDetailData = dayDataMap[dayNumber];

                    // Debug for first few days
                    if (dayNumber <= 3) {
                      print(
                        'Day $dayNumber: ${dayDetailData != null ? "Found (${dayDetailData.date})" : "Not found"}',
                      );
                    }

                    // Determine color and icon based on status
                    Color bgColor = Colors.transparent;
                    Color textColor = Colors.black;
                    IconData? icon;
                    bool hasMultipleBadges = false;

                    if (dayDetailData != null) {
                      String status = dayDetailData.overallStatus;

                      // Check for special day conditions first (highest priority)
                      if (dayDetailData.dayIsWeekend) {
                        bgColor = Colors.grey.shade200;
                        textColor = Colors.grey.shade700;
                        icon = Icons.weekend;
                      } else if (dayDetailData.dayHasHoliday) {
                        bgColor = Colors.purple.shade100;
                        textColor = Colors.purple.shade900;
                        icon = Icons.celebration;
                      } else if (dayDetailData.dayHasLeave) {
                        bgColor = Colors.orange.shade100;
                        textColor = Colors.orange.shade900;
                        icon = Icons.beach_access;
                      } else if (dayDetailData.dayHasOv) {
                        bgColor = Colors.indigo.shade100;
                        textColor = Colors.indigo.shade900;
                        icon = Icons.business_center;
                      }
                      // Then check overall status for attendance
                      else if (status.toLowerCase().contains('present')) {
                        bgColor = Colors.green.shade100;
                        textColor = Colors.green.shade900;
                        icon = Icons.check_circle;
                      } else if (status.toLowerCase().contains('absent')) {
                        bgColor = Colors.red.shade100;
                        textColor = Colors.red.shade900;
                        icon = Icons.cancel;
                      } else if (status.toLowerCase().contains('holiday')) {
                        bgColor = Colors.blue.shade100;
                        textColor = Colors.blue.shade900;
                        icon = Icons.celebration;
                      } else if (status.toLowerCase().contains('weekend')) {
                        bgColor = Colors.grey.shade100;
                        textColor = Colors.grey.shade900;
                        icon = Icons.weekend;
                      } else if (status.toLowerCase().contains('leave')) {
                        bgColor = Colors.orange.shade100;
                        textColor = Colors.orange.shade900;
                        icon = Icons.airplane_ticket;
                      }

                      // Check if there are multiple special conditions
                      int specialCount = 0;
                      if (dayDetailData.dayHasLeave) specialCount++;
                      if (dayDetailData.dayHasOv) specialCount++;
                      if (dayDetailData.dayHasHoliday) specialCount++;
                      if (dayDetailData.hasMultipleShifts) specialCount++;

                      hasMultipleBadges = specialCount > 1;
                    }

                    return Expanded(
                      child: InkWell(
                        onTap: dayDetailData != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AttendanceDayDetail(
                                      detailData: dayDetailData!,
                                    ),
                                  ),
                                );
                              }
                            : null, // Disable tap if no data for this day
                        child: Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                            border: hasMultipleBadges
                                ? Border.all(color: Colors.amber, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$dayNumber',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (icon != null)
                                      Icon(icon, size: 10, color: textColor),
                                  ],
                                ),
                                // Multiple shifts indicator
                                if (dayDetailData?.hasMultipleShifts == true)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(
                  Colors.green,
                  AppLocalizations.of(context)!.present,
                ),
                _buildLegendItem(
                  Colors.red,
                  AppLocalizations.of(context)!.absent,
                ),
                _buildLegendItem(
                  Colors.purple,
                  AppLocalizations.of(context)!.holidays,
                ),
                _buildLegendItem(
                  Colors.orange,
                  AppLocalizations.of(context)!.approvedLeave,
                ),
                _buildLegendItem(Colors.indigo, "OV"),
                _buildLegendItem(Colors.grey, "Weekend"),
                _buildLegendWithDot(Colors.deepPurple, "Multiple"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get weekday number from day name
  int _getWeekdayNumber(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'sunday':
        return 1;
      case 'monday':
        return 2;
      case 'tuesday':
        return 3;
      case 'wednesday':
        return 4;
      case 'thursday':
        return 5;
      case 'friday':
        return 6;
      case 'saturday':
        return 7;
      default:
        return 1; // Default to Sunday
    }
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildLegendWithDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  String _getNepaliMonthName(int month) {
    final months = [
      "Baisakh",
      "Jestha",
      "Ashadh",
      "Shrawan",
      "Bhadra",
      "Ashwin",
      "Kartik",
      "Mangsir",
      "Poush",
      "Magh",
      "Falgun",
      "Chaitra",
    ];
    return months[month - 1];
  }
}
