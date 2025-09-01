import 'package:attendance/feature/ledger/pages/widgets/custom_calendar_widgets.dart';
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
                          summaryData: state.ledgerModel!.summaryData!,
                          detailData: state.ledgerModel!.detailData!,
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
