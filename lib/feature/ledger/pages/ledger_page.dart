import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  int? selectedYear;
  int? selectedMonth;
  String? selectedStringMonth;

  final List<String> nepaliMonths = [
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

  Future<void> _pickYearMonthDialog() async {
    int tempYear = NepaliDateTime.now().year;
    int tempMonth = NepaliDateTime.now().month;

    final int startYear = 2060;
    final int endYear = NepaliDateTime.now().year;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Select Year & Month"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year Dropdown
                  DropdownButton<int>(
                    value: tempYear,
                    isExpanded: true,
                    items: List.generate(endYear - startYear + 1, (index) {
                      int year = startYear + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text("$year"),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          tempYear = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Month Dropdown
                  DropdownButton<int>(
                    value: tempMonth,
                    isExpanded: true,
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(nepaliMonths[index]),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          tempMonth = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(ctx),
                ),
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    setState(() {
                      selectedYear = tempYear;
                      selectedMonth = tempMonth;
                      selectedStringMonth = nepaliMonths[tempMonth - 1];
                    });
                    Navigator.pop(ctx);

                    // Fetch data for the selected month
                    context.read<LedgerProvider>().fetchLedgerData(
                      year: selectedYear,
                      month: selectedMonth,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    selectedYear = NepaliDateTime.now().year;
    selectedMonth = NepaliDateTime.now().month;
    selectedStringMonth = nepaliMonths[NepaliDateTime.now().month];

    // Fetch initial data
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<LedgerProvider>().fetchLedgerData(
    //     year: selectedYear,
    //     month: selectedMonth,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("Attendance Ledger"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
      ),
      body: Consumer<LedgerProvider>(
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Date selection card
                InkWell(
                  onTap: _pickYearMonthDialog,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedStringMonth != null
                                  ? "$selectedStringMonth $selectedYear"
                                  : "Select Year & Month",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.blue),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('h:mm a').format(DateTime.now()),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Summary statistics
                if (state.ledgerModel?.summaryData != null)
                  _buildSummaryCard(state.ledgerModel!.summaryData!),

                const SizedBox(height: 15),

                // Calendar view
                Expanded(
                  child: state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : CustomCalendarWidget(
                          year: selectedYear!,
                          month: selectedMonth!,
                          ledgerProvider: state,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(SummaryData summary) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Total", summary.total.toString(), Colors.blue),
          _buildSummaryItem(
            "Present",
            summary.present.toString(),
            Colors.green,
          ),
          _buildSummaryItem("Absent", summary.absent.toString(), Colors.red),
          _buildSummaryItem("Leave", summary.leave.toString(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class CustomCalendarWidget extends StatelessWidget {
  final int year;
  final int month;
  final LedgerProvider ledgerProvider;

  const CustomCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.ledgerProvider,
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

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
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

                    // Determine color and icon based on status
                    Color bgColor = Colors.transparent;
                    Color textColor = Colors.black;
                    IconData? icon;

                    if (status != null) {
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
