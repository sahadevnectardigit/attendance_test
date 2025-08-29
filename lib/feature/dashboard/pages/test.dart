import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/utils/device_helper.dart';
import 'package:attendance/feature/dashboard/pages/screens/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AttendanceDashboardPage extends StatefulWidget {
  const AttendanceDashboardPage({super.key});

  @override
  State<AttendanceDashboardPage> createState() =>
      _AttendanceDashboardPageState();
}

class _AttendanceDashboardPageState extends State<AttendanceDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        title: const Text(
          "Hey there!",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
        child: Column(
          children: [
            // Date and Time Row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                children: const [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 6),
                      Text(
                        "08 Feb 2020",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 6),
                      Text(
                        "4:32 PM",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true, // ✅ Important for scroll inside scroll
                physics:
                    const NeverScrollableScrollPhysics(), // ✅ Disable inner scroll
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildStatCard("Paid Leaves", "06", "Left", Colors.red),
                  buildStatCard("Half Days", "01", "", Colors.green),
                  buildStatCard("Absent Hours", "188", "Hours", Colors.orange),
                  buildStatCard("Holidays", "05", "", Colors.purple),
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
