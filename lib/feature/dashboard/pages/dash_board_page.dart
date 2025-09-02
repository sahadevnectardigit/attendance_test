import 'package:attendance/core/widgets/dashboard_shimmer.dart';
import 'package:attendance/feature/dashboard/pages/screens/app_drawer.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

  // Step 1: Predefine the keys you want and their colors
  final List<String> categories = [
    "Present",
    "Absent",
    "LateIn",
    "EarlyOut",
    "Holiday",
    "Approved Leave",
    "Weekend",
    "Official Visit",
  ];

  final List<Color> categoryColors = [
    Colors.green, // Present
    Colors.red, // Absent
    Colors.orange, // LateIn
    Colors.purple, // EarlyOut
    Colors.blue, // Holiday
    Colors.teal, // Approved Leave
    Colors.grey, // Weekend
    Colors.brown, // Official Visit
  ];

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final dashBoardProvider = context.watch<DashboardProvider>();
    final dashBoardData = dashBoardProvider.dashboard;
    final profilePro = context.read<ProfileProvider>();
    // ✅ For Pie Chart
    // final Map<String, double> months =
    //     dashBoardData?.monthlyStats?.toChartData() ?? {};
    // Step 2: Convert API data into a fixed map
    final Map<String, double> months = {
      for (var key in categories)
        key: dashBoardData?.monthlyStats?.toChartData()[key] ?? 0.0,
    };

    return dashBoardProvider.isLoading
        ? DashboardShimmer()
        : dashBoardProvider.errorMessage != null
        ? Center(child: Text(dashBoardProvider.errorMessage!))
        : Scaffold(
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
                      // return Text('image');
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(child: CupertinoActivityIndicator()),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/profile_icon.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "Hey ${profilePro.profileModel?.firstName ?? "there!"}",
                    style: const TextStyle(
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
            drawer: AppDrawer(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
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
                            // const Icon(
                            //   Icons.calendar_today,
                            //   color: Colors.blue,
                            // ),
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
                            // Icon(Icons.access_time, color: Colors.blue),
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

                  ///Pie Chart
                  PieChart(
                    dataMap: months,
                    colorList: categoryColors, // colors match keys
                    chartRadius: MediaQuery.sizeOf(context).width * 0.7,
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.bottom,
                      showLegendsInRow: true, // horizontal layout
                      legendShape: BoxShape.circle,
                      legendTextStyle: const TextStyle(fontSize: 10),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      decimalPlaces: 0,
                      chartValueStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

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
