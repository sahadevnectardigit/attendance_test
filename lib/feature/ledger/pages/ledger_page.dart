import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/widgets/loading_widget.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
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

  /// Custom Year-Month Picker Dialog
  Future<void> _pickYearMonthDialog() async {
    int tempYear = NepaliDateTime.now().year;
    int tempMonth = NepaliDateTime.now().month;

    final int startYear = 1970;
    final int endYear = NepaliDateTime.now().year; // current Nepali year

    await showDialog(
      context: context,
      builder: (ctx) {
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
                  return DropdownMenuItem(value: year, child: Text("$year"));
                }),
                onChanged: (val) {
                  if (val != null) {
                    tempYear = val;
                    setState(() {}); // refresh inside dialog
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
                    tempMonth = val;
                    setState(() {}); // refresh inside dialog
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
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,

      appBar: AppBar(
        title: const Text("Ledger"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Consumer<LedgerProvider>(
        builder: (context, state, _) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await _pickYearMonthDialog();
                      if (selectedYear != null && selectedMonth != null) {
                        final isSuccess = await state.fetchLedgerData(
                          year: selectedYear,
                          month: selectedMonth,
                        );
                        if (isSuccess) {
                          context.showSnackBarMessage(
                            message: 'Data loaded successfully',
                            backgroundColor: Colors.green,
                          );
                        } else {
                          context.showSnackBarMessage(
                            message: state.errorMessage.toString(),
                            backgroundColor: Colors.red,
                          );
                        }
                      }
                    },
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

                  state.isLoading
                      ? LoadingWidget()
                      : Expanded(
                          child: ListView.separated(
                            itemCount:
                                state.ledgerModel?.detailData?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final detailData =
                                  state.ledgerModel?.detailData?[index];
                              return Card(
                                color: Colors.blue.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _infoRow("Date", detailData?.date),
                                      _infoRow("Day", detailData?.day),
                                      _infoRow("Remarks", detailData?.remarks),
                                      const Divider(height: 16, thickness: 1),
                                      _infoRow("Time In", detailData?.timeIn),
                                      _infoRow("Time Out", detailData?.timeOut),
                                      _infoRow(
                                        "Worked Hour",
                                        detailData?.workedHour,
                                      ),
                                      _infoRow("OT", detailData?.ot),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return SizedBox(height: 5);
                                },
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            value ?? "N/A",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
