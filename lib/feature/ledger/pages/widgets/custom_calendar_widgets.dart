import 'package:attendance/feature/ledger/pages/attendance_monthly_details.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class CustomCalendarWidget extends StatelessWidget {
  final int year;
  final int month;
  final LedgerProvider ledgerProvider;
  final List<DetailData> detailData;
  final SummaryData summaryData;

  const CustomCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.ledgerProvider,
    required this.detailData,
    required this.summaryData,
  });

  @override
  Widget build(BuildContext context) {
    // Get all dates from the API response
    final allDates = ledgerProvider.getAllDates();

    // Determine the maximum day in the month from the API data
    int maxDay = 0;
    for (var date in allDates) {
      try {
        final parts = date.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[2]);
          if (day != null && day > maxDay) {
            maxDay = day;
          }
        }
      } catch (e) {
        // Ignore invalid dates
      }
    }

    // If we couldn't determine maxDay from data, use a default
    if (maxDay == 0) maxDay = 32;

    // Find the weekday of the first day of the month
    // We'll use the API data to determine this
    int firstWeekday = 7; // Default to Sunday if not found

    for (var date in allDates) {
      try {
        final parts = date.split('/');
        if (parts.length == 3 && parts[2] == '01') {
          // This is the first day of the month, get its weekday
          final dayName = ledgerProvider.getDayName(date);
          firstWeekday = _getWeekdayNumber(dayName);
          break;
        }
      } catch (e) {
        // Ignore invalid dates
      }
    }

    // Calculate total cells needed (including empty cells at the beginning)
    int totalCells = maxDay + firstWeekday - 1;
    int rows = (totalCells / 7).ceil();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AttendanceMonthlyDetails(
              detailData: detailData,
              summaryData: summaryData,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Month and year header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "${_getNepaliMonthName(month)} $year",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),

            // Weekday headers
            Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (day) => Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
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

                      // Format the date to match API response format (YYYY/MM/DD)
                      String formattedDate =
                          '$year/${month.toString().padLeft(2, '0')}/${dayNumber.toString().padLeft(2, '0')}';
                      String? status = ledgerProvider.getAttendanceStatus(
                        formattedDate,
                      );
                      String? day = ledgerProvider.getAttendanceDay(
                        formattedDate,
                      );

                      // Determine color and icon based on status
                      Color bgColor = Colors.transparent;
                      Color textColor = Colors.black;
                      IconData? icon;

                      // First, check for Saturday
                      if (day != null && day.toLowerCase().contains('sat')) {
                        bgColor = Colors.red.shade100;
                      } else if (status != null) {
                        if (status.toLowerCase().contains('present')) {
                          bgColor = Colors.green.shade100;
                          textColor = Colors.green.shade900;
                          icon = Icons.check_circle;
                        } else if (status.toLowerCase().contains('absent')) {
                          bgColor = Colors.red.shade100;
                          textColor = Colors.red.shade900;
                          icon = Icons.cancel;
                        } else if (status.toLowerCase().contains('holiday') ||
                            status.toLowerCase().contains('weekend')) {
                          bgColor = Colors.blue.shade100;
                          textColor = Colors.blue.shade900;
                          icon = Icons.beach_access;
                        } else if (status.toLowerCase().contains('leave')) {
                          bgColor = Colors.orange.shade100;
                          textColor = Colors.orange.shade900;
                          icon = Icons.airplane_ticket;
                        }
                      }

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                if (icon != null)
                                  Icon(icon, size: 12, color: textColor),
                              ],
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
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildLegendItem(Colors.green, 'Present'),
                  _buildLegendItem(Colors.red, 'Absent'),
                  _buildLegendItem(Colors.blue, 'Holiday/Weekend'),
                  _buildLegendItem(Colors.orange, 'Leave'),
                ],
              ),
            ),
          ],
        ),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12)),
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
