import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/feature/dashboard/pages/dash_board_page.dart';
import 'package:attendance/feature/ledger/pages/ledger_page.dart';
import 'package:attendance/feature/profile/page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  final List<Widget> _pages = const [
    DashboardPage(),
    Center(child: Text("💰 Salary Page", style: TextStyle(fontSize: 22))),
    LedgerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      // body: IndexedStack(index: navProvider.currentIndex, children: _pages),
      body: _pages[navProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.currentIndex,
        onTap: navProvider.updateIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
    );
  }
}
