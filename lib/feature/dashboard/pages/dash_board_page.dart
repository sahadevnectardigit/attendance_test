import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/utils/device_helper.dart';
import 'package:attendance/feature/dashboard/pages/screens/app_drawer.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // NepaliDateTime? _selectedDate;
  int? selectedYear;
  int? selectedMonth;
  String? selectedStringMonth;
  int? selectedDay;
  // selectedYear = NepaliDateTime.now().year;
  //   selectedMonth = NepaliDateTime.now().month;
  //   selectedStringMonth = nepaliMonths[NepaliDateTime.now().month];

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

  // Future<void> _pickNepaliDate() async {
  //   final selectedDateTime = await showNepaliDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? NepaliDateTime.now(),
  //     firstDate: NepaliDateTime(1970, 2, 5),
  //     lastDate: NepaliDateTime.now(),
  //     initialDatePickerMode: DatePickerMode.day,
  //   );

  //   if (selectedDateTime != null) {
  //     setState(() {
  //       _selectedDate = selectedDateTime;
  //       selectedYear = selectedDateTime.year;
  //       selectedMonth = selectedDateTime.month;
  //       selectedDay = selectedDateTime.day;
  //       selectedStringMonth = nepaliMonths[selectedMonth! - 1]; // 👈 map here
  //     });

  //     // Print or send request here
  //     final requestPayload = {"year": selectedYear, "month": selectedMonth};

  //     print("Request Payload: $requestPayload");
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<DashboardProvider>().fetchDashboard();
  //     context.read<ProfileProvider>().fetchProfileData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final dashBoardProvider = context.watch<DashboardProvider>();
    final dashBoardData = dashBoardProvider.dashboard;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        titleSpacing: 0,

        title: Row(
          children: [
            Consumer<ProfileProvider>(
              builder: (context, data, _) {
                final imageUrl = data.profileModel?.profile?.imageUrl;

                if (imageUrl == null || imageUrl.isEmpty) {
                  // Return a placeholder or default avatar
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/profile_icon.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imageUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Optional fallback if image fails to load
                      return Image.asset(
                        'assets/images/profile_icon.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(width: 8),

            const Text(
              "Hey there!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: dashBoardProvider.isLoading
            ? Center(child: const CircularProgressIndicator())
            : dashBoardProvider.errorMessage != null
            ? Text(dashBoardProvider.errorMessage!)
            : Column(
                children: [
                  // Date and Time Row
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
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
                                  ? "$selectedStringMonth,$selectedMonth $selectedYear"
                                  : dashBoardData?.nepaliMonth ?? "N/A",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue),
                            SizedBox(width: 6),
                            Text(
                              DateFormat(
                                'h:mm a',
                              ).format(DateTime.now()), // e.g. 4:32 PM
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                
                  // Swipe to check in button
                  const SizedBox(height: 30),

                  // Stats Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Wrap(
                      spacing: 10, // Horizontal space between items
                      runSpacing: 10, // Vertical space between rows
                      children: [
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Present",
                            "${dashBoardData?.monthlyStats?.present ?? 0}",
                            // "${ledgerData?.summary?.present ?? 0}",
                            "",
                            Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Absent",
                            "${dashBoardData?.monthlyStats?.absent ?? 0}",

                            // "${ledgerData?.summary?.absent ?? 0}",
                            "",
                            Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Late in",
                            "${dashBoardData?.monthlyStats?.lateIn ?? 0}",

                            // "${ledgerData?.summary?.lateIn ?? 0}",
                            "",
                            Colors.orange,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Early Out",
                            "${dashBoardData?.monthlyStats?.earlyOut ?? 0}",
                            // "${ledgerData?.summary?.earlyOut ?? 0}",
                            "",
                            Colors.purple,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Holidays",
                            "${dashBoardData?.monthlyStats?.holiday ?? 0}",

                            // "${ledgerData?.summary?.holiday ?? 0}",
                            "",
                            Colors.purple,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          height: 110,
                          child: buildStatCard(
                            "Approved leave",
                            "${dashBoardData?.monthlyStats?.approvedLeave ?? 0}",

                            // "${ledgerData?.summary?.leave ?? 0}",
                            "",
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildStatCard(
    String title,
    String value,
    String subText,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (subText.isNotEmpty)
            Text(
              subText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
