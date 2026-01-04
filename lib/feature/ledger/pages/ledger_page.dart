import 'dart:developer';

import 'package:attendance/feature/dutyRoster/system_setting_provider.dart';
import 'package:attendance/feature/ledger/pages/widgets/custom_calendar_widgets.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/l10n/app_localizations.dart';
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

  // Green theme colors
  final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

  final List<Color> lightGreenGradient = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];
  bool systemSettingValue = false;
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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: lightGreenGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Year & Month",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Year Dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: DropdownButton<int>(
                        value: tempYear,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF2E7D32),
                        ),
                        items: List.generate(endYear - startYear + 1, (index) {
                          int year = startYear + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              "$year",
                              style: TextStyle(color: Color(0xFF2E7D32)),
                            ),
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
                    ),
                    SizedBox(height: 15),

                    // Month Dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: DropdownButton<int>(
                        value: tempMonth,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF2E7D32),
                        ),
                        items: List.generate(12, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              nepaliMonths[index],
                              style: TextStyle(color: Color(0xFF2E7D32)),
                            ),
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
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("OK"),
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
                            log(
                              'Selected year: $selectedYear, month:$selectedMonth',
                            );
                            // [log] Selected year: 2076, month:9
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    systemSettingValue =
        context.read<SystemSettingProvider>().systemSettingState.data as bool;
    log('System setting value: ..................$systemSettingValue');

    selectedYear = NepaliDateTime.now().year;
    selectedMonth = NepaliDateTime.now().month;
    selectedStringMonth = nepaliMonths[NepaliDateTime.now().month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.attendanceLedger,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<LedgerProvider>(
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Date selection card
                InkWell(
                  onTap: _pickYearMonthDialog,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: greenGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              selectedStringMonth != null
                                  ? "$selectedStringMonth $selectedYear"
                                  : "Select Year & Month",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('h:mm a').format(DateTime.now()),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Summary statistics
                if (state.fetchLedgerState.data?.summaryData != null)
                  _buildSummaryCard(state.fetchLedgerState.data!.summaryData!),
                SizedBox(height: 15),

                // Calendar view
                Expanded(
                  child: state.fetchLedgerState.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4CAF50),
                            ),
                          ),
                        )
                      : CustomCalendarWidget(
                          year: selectedYear!,
                          month: selectedMonth!,
                          ledgerProvider: state,
                          summaryData: state.fetchLedgerState.data?.summaryData,
                          detailData:
                              state.fetchLedgerState.data?.detailData ?? [],
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            AppLocalizations.of(context)!.total,
            summary.total.toString(),
            Color(0xFF2196F3),
          ),
          _buildSummaryItem(
            AppLocalizations.of(context)!.present,
            summary.present.toString(),
            Color(0xFF4CAF50),
          ),
          _buildSummaryItem(
            AppLocalizations.of(context)!.absent,
            summary.absent.toString(),
            Color(0xFFF44336),
          ),
          _buildSummaryItem(
            AppLocalizations.of(context)!.approvedLeave,
            summary.leave.toString(),
            Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
