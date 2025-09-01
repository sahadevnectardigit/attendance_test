// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';

// class MonthlyStatsPieChart extends StatelessWidget {
//   final Map<String, dynamic> response = {
//     "daily_stats": {
//       "Present": 1,
//       "Absent": 0,
//       "LateIn": 1,
//       "EarlyOut": 0,
//       "Holiday": 4,
//       "Approved Leave": 0,
//       "Weekend": 4,
//       "Official Visit": 0
//     },
//     "monthly_stats": {
//       "Present": 2,
//       "Absent": 2,
//       "LateIn": 1,
//       "EarlyOut": 1,
//       "Holiday": 4,
//       "Approved Leave": 0,
//       "Weekend": 4,
//       "Official Visit": 0
//     },
//     "nepali_month": "2082 Bhadra"
//   };

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, double> monthlyStats =
//         (response["monthly_stats"] as Map<String, dynamic>)
//             .map((key, value) => MapEntry(key, (value as num).toDouble()));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Monthly Stats (${response["nepali_month"]})"),
//       ),
//       body: 
//       Center(
//         child: PieChart(
//           dataMap: monthlyStats,
//           chartRadius: MediaQuery.of(context).size.width / 2,
//           legendOptions: LegendOptions(
//             showLegends: true,
//             legendPosition: LegendPosition.right,
//             legendShape: BoxShape.circle,
//             legendTextStyle: TextStyle(fontSize: 14),
//           ),
//           chartValuesOptions: ChartValuesOptions(
//             showChartValuesInPercentage: true,
//             showChartValues: true,
//             decimalPlaces: 1,
//           ),
//         ),
//       ),
    
//     );
//   }
// }


// // Step 1: Predefine the keys you want and their colors
// final List<String> categories = [
//   "Present",
//   "Absent",
//   "LateIn",
//   "EarlyOut",
//   "Holiday",
//   "Approved Leave",
//   "Weekend",
//   "Official Visit",
// ];

// final List<Color> categoryColors = [
//   Colors.green,    // Present
//   Colors.red,      // Absent
//   Colors.orange,   // LateIn
//   Colors.purple,   // EarlyOut
//   Colors.blue,     // Holiday
//   Colors.teal,     // Approved Leave
//   Colors.grey,     // Weekend
//   Colors.brown,    // Official Visit
// ];

// // Step 2: Convert API data into a fixed map
// final Map<String, double> months = {
//   for (var key in categories)
//     key: dashBoardData?.monthlyStats?.toChartData()[key] ?? 0.0,
// };

// // Step 3: Pass to PieChart
// PieChart(
//   dataMap: months,
//   colorList: categoryColors, // colors match keys
//   chartRadius: MediaQuery.sizeOf(context).width * 0.7,
//   legendOptions: LegendOptions(
//     showLegends: true,
//     legendPosition: LegendPosition.bottom,
//     showLegendsInRow: true, // horizontal layout
//     legendShape: BoxShape.circle,
//     legendTextStyle: const TextStyle(fontSize: 12),
//   ),
//   chartValuesOptions: const ChartValuesOptions(
//     showChartValues: true,
//     showChartValuesInPercentage: true,
//     decimalPlaces: 0,
//     chartValueStyle: TextStyle(
//       fontSize: 10,
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
// ),
