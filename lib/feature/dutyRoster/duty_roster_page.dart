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
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final String day = entry.key;
              final List<Shift> shifts = entry.value;

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                      const SizedBox(height: 8),

                      // ✅ loop through shifts using MODEL
                      ...shifts.map((shift) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  shift.shift.isNullOrEmpty
                                      ? 'No Shift'
                                      : shift.shift!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Row(
                                children: [
                                  if (shift.dayOff ?? false)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text("Day Off"),
                                    ),
                                  if (shift.nightOff ?? false)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text("Night"),
                                    ),
                                  if (shift.exchange ?? false)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text("Exchange"),
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
          );
        },
      ),
    );
  }
}
