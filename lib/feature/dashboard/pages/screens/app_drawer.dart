import 'package:attendance/feature/dashboard/pages/official_application_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.09),
          // Drawer Header
          // UserAccountsDrawerHeader(
          //   decoration: BoxDecoration(color: Colors.blue),
          //   accountName: Text("John Doe"),
          //   accountEmail: Text("john.doe@example.com"),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundColor: Colors.white,
          //     child: Icon(Icons.person, size: 40, color: Colors.blue),
          //   ),
          // ),
          // Divider(),
          Text(
            'Application Section',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          Divider(),

          // Applications section
          ListTile(
            leading: Icon(Icons.work),
            title: Text("Official Application"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OfficialApplicationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.airplane_ticket),
            title: Text("Leave Application"),
            onTap: () {
              Navigator.pushNamed(context, '/leave_application');
            },
          ),
          ListTile(
            leading: Icon(Icons.home_work),
            title: Text("Work From Home"),
            onTap: () {
              Navigator.pushNamed(context, '/work_from_home');
            },
          ),
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text("Shift Change"),
            onTap: () {
              Navigator.pushNamed(context, '/shift_change');
            },
          ),

          Spacer(),
          Divider(),

          // Logout button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: handle logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
