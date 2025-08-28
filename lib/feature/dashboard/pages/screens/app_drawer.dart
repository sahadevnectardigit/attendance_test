import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          Container(
            width: 250,
            color: Color(0xFF4A6CF7),
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Home', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    print('Home tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.white),
                  title: Text(
                    'Notifications',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Notifications tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message, color: Colors.white),
                  title: Text(
                    'Messages',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Messages tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.visibility, color: Colors.white),
                  title: Text(
                    'Overview',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Overview tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.report_problem, color: Colors.white),
                  title: Text(
                    'Action - Leave / Concern',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Action tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text(
                    'Client Visit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print('Client Visit tapped');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Logout', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    print('Logout tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
