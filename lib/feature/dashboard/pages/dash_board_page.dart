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
    Color(0xFF4CAF50), // Present - Green
    Color(0xFFF44336), // Absent - Red
    Color(0xFFFF9800), // LateIn - Orange
    Color(0xFF9C27B0), // EarlyOut - Purple
    Color(0xFF2196F3), // Holiday - Blue
    Color(0xFF009688), // Approved Leave - Teal
    Color(0xFF607D8B), // Weekend - Grey
    Color(0xFF795548), // Official Visit - Brown
  ];

  // Green gradient colors
  final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

  final List<Color> lightGreenGradient = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    final dashBoardProvider = context.watch<DashboardProvider>();
    final dashBoardData = dashBoardProvider.fetchDashBoardState.data;
    final profilePro = context.read<ProfileProvider>();

    final Map<String, double> months = {
      for (var key in categories)
        key: dashBoardData?.monthlyStats?.toChartData()[key] ?? 0.0,
    };

    return dashBoardProvider.fetchDashBoardState.isLoading
        ? DashboardShimmer()
        : dashBoardProvider.fetchDashBoardState.error != null
        ? Center(child: Text(dashBoardProvider.fetchDashBoardState.error!))
        : Scaffold(
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
              iconTheme: IconThemeData(color: Colors.white),

              titleSpacing: 0,
              title: Row(
                children: [
                  Consumer<ProfileProvider>(
                    builder: (context, data, _) {
                      final imageUrl =
                          data.fetchProfileState.data?.profile?.imageUrl;

                      if (imageUrl == null || imageUrl.isEmpty) {
                        // Return a placeholder or default avatar
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: greenGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 20,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: greenGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: greenGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  Text(
                    "Hey ${profilePro.fetchProfileState.data?.firstName ?? "there!"}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
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
                      vertical: 16,
                    ),
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
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selectedStringMonth != null
                                  ? "$selectedStringMonth,$selectedMonth $selectedYear"
                                  : dashBoardData?.nepaliMonth ?? "N/A",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'h:mm a',
                              ).format(DateTime.now()), // e.g. 4:32 PM
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///Pie Chart
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: PieChart(
                      dataMap: months,
                      colorList: categoryColors, // colors match keys
                      chartRadius: MediaQuery.sizeOf(context).width * 0.5,
                      legendOptions: LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.bottom,
                        showLegendsInRow: true, // horizontal layout
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        decimalPlaces: 0,
                        chartValueStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        chartValueBackgroundColor: Colors.green[800],
                      ),
                      chartType: ChartType.ring,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Monthly Statistics",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 10, // Horizontal space between items
                          runSpacing: 10, // Vertical space between rows
                          children: [
                            buildStatCard(
                              cardWidth,
                              "Present",
                              "${dashBoardData?.monthlyStats?.present ?? 0}",
                              "",
                              Color(0xFF4CAF50),
                            ),
                            buildStatCard(
                              cardWidth,
                              "Absent",
                              "${dashBoardData?.monthlyStats?.absent ?? 0}",
                              "",
                              Color(0xFFF44336),
                            ),
                            buildStatCard(
                              cardWidth,
                              "Late in",
                              "${dashBoardData?.monthlyStats?.lateIn ?? 0}",
                              "",
                              Color(0xFFFF9800),
                            ),
                            buildStatCard(
                              cardWidth,
                              "Early Out",
                              "${dashBoardData?.monthlyStats?.earlyOut ?? 0}",
                              "",
                              Color(0xFF9C27B0),
                            ),
                            buildStatCard(
                              cardWidth,
                              "Holidays",
                              "${dashBoardData?.monthlyStats?.holiday ?? 0}",
                              "",
                              Color(0xFF2196F3),
                            ),
                            buildStatCard(
                              cardWidth,
                              "Approved leave",
                              "${dashBoardData?.monthlyStats?.approvedLeave ?? 0}",
                              "",
                              Color(0xFF009688),
                            ),
                          ],
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
    double width,
    String title,
    String value,
    String subText,
    Color color,
  ) {
    return Container(
      width: width,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
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
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          if (subText.isNotEmpty)
            Text(
              subText,
              style: TextStyle(
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
