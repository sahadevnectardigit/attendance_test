import 'dart:developer';

import 'package:attendance/core/extension/string_validators.dart';
import 'package:attendance/core/widgets/loading.dart';
import 'package:attendance/feature/dutyRoster/duty_roster_model.dart';
import 'package:attendance/feature/dutyRoster/duty_roster_provider.dart';
import 'package:attendance/feature/dutyRoster/system_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DutyRosterPage extends StatefulWidget {
  const DutyRosterPage({super.key});

  @override
  State<DutyRosterPage> createState() => _DutyRosterPageState();
}

class _DutyRosterPageState extends State<DutyRosterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final res = context.read<SystemSettingProvider>().systemSettingState.data;

      context.read<DutyRosterProvider>().fetchDutyRoster(
        nepaliEnabled: res ?? false,
      );
      log('System setting value: ..................$res');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
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
        title: const Text(
          'Duty Roster',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<DutyRosterProvider>(
        builder: (context, state, child) {
          final rosterData = state.dutyRosterState.data;

          final daysData = rosterData?.rosterData?.days;
          final entries = daysData?.entries.toList() ?? [];

          if (state.dutyRosterState.isLoading) {
            // return LoadingWidget();
            return buildLoadingState();
          }
          if (state.dutyRosterState.hasError) {
            return Center(child: Text(state.dutyRosterState.error ?? ""));
          }

          // Add header with person name if available
          return Column(
            children: [
              // Person Name Header
              if (rosterData?.rosterData?.personName != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Employee: ${rosterData!.rosterData!.personName!}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (rosterData.rosterData?.department != null)
                        Text(
                          "Dept: ${rosterData.rosterData!.department!}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

              // Days List
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final String day = entry.key;
                    final DayData dayData = entry.value;
                    final List<RosterEntry>? rosterEntries =
                        dayData.rosterEntries;

                    if (rosterEntries == null || rosterEntries.isEmpty) {
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(0),//8
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Day $day",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "No roster entries",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day header with weekday
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Day $day",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (rosterEntries.isNotEmpty &&
                                    rosterEntries.first.weekdayFull != null)
                                  Text(
                                    rosterEntries.first.weekdayFull!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // ✅ loop through roster entries using UPDATED MODEL
                            ...rosterEntries.map((rosterEntry) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rosterEntry.shift.isNullOrEmpty
                                                ? 'No Shift'
                                                : rosterEntry.shift!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          //   if (rosterEntry.weekdayShort != null)
                                          //     Text(
                                          //       rosterEntry.weekdayShort!,
                                          //       style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: Colors.grey.shade600,
                                          //       ),
                                          //     ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (rosterEntry.dayOff ?? false)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.blue.shade200,
                                              ),
                                            ),
                                            child: const Text(
                                              "Day Off",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        if (rosterEntry.nightOff ?? false)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.purple.shade200,
                                              ),
                                            ),
                                            child: const Text(
                                              "Night Off",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        if (rosterEntry.exchange ?? false)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Colors.orange.shade200,
                                              ),
                                            ),
                                            child: const Text(
                                              "Exchange",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
