import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeDashboardProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider = context.watch<EmployeeDashboardProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      
      body: Center(
        child: dashBoardProvider.isLoading
            ? const CircularProgressIndicator()
            : dashBoardProvider.errorMessage != null
            ? Text(dashBoardProvider.errorMessage!)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nepali Month: ${dashBoardProvider.dashboard?.nepaliMonth ?? '-'}",
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Daily Present: ${dashBoardProvider.dashboard?.dailyStats?.present ?? 0}",
                  ),
                  Text(
                    "Daily Absent: ${dashBoardProvider.dashboard?.dailyStats?.absent ?? 0}",
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Monthly Present: ${dashBoardProvider.dashboard?.monthlyStats?.present ?? 0}",
                  ),
                  Text(
                    "Monthly Absent: ${dashBoardProvider.dashboard?.monthlyStats?.absent ?? 0}",
                  ),
                ],
              ),
      ),
    );
  }
}
