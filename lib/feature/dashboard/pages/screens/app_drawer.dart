import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
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
      child: Container(
        width: 250,
        color: Color(0xFF4A6CF7),

        // color: Colors.blue.shade50,
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
              title: Text('Messages', style: TextStyle(color: Colors.white)),
              onTap: () {
                print('Messages tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility, color: Colors.white),
              title: Text('Overview', style: TextStyle(color: Colors.white)),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(
                              context,
                            ).pop(); // Close the dialog first
                            // Clear login state
                            await LocalStorage.clearTokens();
                            await LocalStorage.setRememberMe(false);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceLoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
           
            ),
          ],
        ),
      ),
    );
  }
}
