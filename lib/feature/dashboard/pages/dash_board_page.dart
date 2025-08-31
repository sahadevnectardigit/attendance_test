import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/utils/device_helper.dart';
import 'package:attendance/feature/dashboard/pages/screens/app_drawer.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  NepaliDateTime? _selectedDate;
  int? selectedYear;
  int? selectedMonth;
  String? selectedStringMonth;
  int? selectedDay;

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

  Future<void> _pickNepaliDate() async {
    final selectedDateTime = await showNepaliDatePicker(
      context: context,
      initialDate: _selectedDate ?? NepaliDateTime.now(),
      firstDate: NepaliDateTime(1970, 2, 5),
      lastDate: NepaliDateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (selectedDateTime != null) {
      setState(() {
        _selectedDate = selectedDateTime;
        selectedYear = selectedDateTime.year;
        selectedMonth = selectedDateTime.month;
        selectedDay = selectedDateTime.day;
        selectedStringMonth = nepaliMonths[selectedMonth! - 1]; // 👈 map here
      });

      // Print or send request here
      final requestPayload = {"year": selectedYear, "month": selectedMonth};

      print("Request Payload: $requestPayload");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard();
      context.read<ProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final dashBoardProvider = context.watch<DashboardProvider>();
    final dashBoardData = dashBoardProvider.dashboard;
    final ledgerProvider = context.watch<LedgerProvider>();
    // final ledgerData = ledgerProvider.ledgerModel;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        titleSpacing: 0, // 👈 this removes the default gap

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
                        'assets/images/default_avatar.png',
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
        child: ledgerProvider.isLoading
            ? Center(child: const CircularProgressIndicator())
            : ledgerProvider.errorMessage != null
            ? Text(ledgerProvider.errorMessage!)
            : Column(
                children: [
                  // Date and Time Row
                  InkWell(
                    onTap: () async {
                      // await _pickNepaliDate();
                      // final isSuccess = await ledgerProvider.fetchLedgerData(
                      //   year: selectedYear,
                      //   month: selectedMonth,
                      // );
                      // if (isSuccess) {
                      //   context.showSnackBarMessage(
                      //     message: 'Successfully load data',
                      //     backgroundColor: Colors.green,
                      //   );
                      // } else {
                      //   context.showSnackBarMessage(
                      //     message: ledgerProvider.errorMessage.toString(),
                      //     backgroundColor: Colors.red,
                      //   );
                      // }
                    },
                    child: Container(
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
                  ),

                  const SizedBox(height: 20),

                  // Timer Circle
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 10,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "00h 00m",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Checked in at 10:35 AM",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "View live location",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Start your day",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    child: SlideAction(
                      height: 65,
                      text: "Swipe to check in",
                      outerColor: Colors.blue,
                      innerColor: Colors.white,
                      sliderButtonIcon: const Icon(
                        Icons.arrow_right_alt_sharp,
                        color: Colors.blue,
                      ),
                      onSubmit: () async {
                        final deviceName = await DeviceHelper.getDeviceName();

                        /// Do something here OnSlide
                        context.showSnackBarMessage(
                          message: 'Attendance successful on $deviceName ',
                          backgroundColor: Colors.green,
                        );
                        return null;
                      },
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
