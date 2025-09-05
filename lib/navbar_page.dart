import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/feature/dashboard/pages/dash_board_page.dart';
import 'package:attendance/feature/ledger/pages/ledger_page.dart';
import 'package:attendance/feature/profile/page/profile_page.dart';
import 'package:attendance/feature/salary/page/salary_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarPage extends StatelessWidget {
  NavBarPage({super.key});

  final List<Widget> _pages = [
    DashboardPage(),
    SalaryPage(),
    LedgerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            colors: [Color(0xFF2ecc71), Color(0xFF27ae60)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IndexedStack(index: navProvider.currentIndex, children: _pages),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF27ae60), Color(0xFF1e8449)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: navProvider.currentIndex,
          onTap: navProvider.updateIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: "Salary",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Ledger"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
