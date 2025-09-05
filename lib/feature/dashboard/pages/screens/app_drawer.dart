import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/feature/dashboard/pages/latein_earlyout_applist_page.dart';
import 'package:attendance/feature/dashboard/pages/latein_lateout_page.dart';
import 'package:attendance/feature/dashboard/pages/leave_app_list_page.dart';
import 'package:attendance/feature/dashboard/pages/official_application_list_page.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/models/official_application_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  // Example usage with your API response
  // Mock API Response (as Map list)
  List<Map<String, dynamic>> mockApiResponse = [
    {
      "id": 47,
      "name": {"id": 2, "name": "Sales Meeting", "short_name": "SM"},
      "person": 7,
      "from_date_en": "2025-09-05",
      "from_date_np": "2082-05-20",
      "to_date_en": "2025-09-05",
      "to_date_np": "2082-05-20",
      "approved_by": 2,
      "recommended_by": 1,
      "approved": false,
      "approved_date": null,
      "recommended_date": null,
      "days": "1.00",
      "half_day": false,
      "remarks": "",
      "applied_date": "2025-09-05",
      "place": "vsvsv",
      "allowance_claimed": "0.00",
      "viewed": false,
      "current_status": "Pending",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Convert into model
    List<OfficialApplicationListModel> apiResponse =
        OfficialApplicationListModel.listFromJson(mockApiResponse);
    // Green theme colors
    final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

    final List<Color> lightGreenGradient = [
      Color(0xFFE8F5E9),
      Color(0xFFC8E6C9),
    ];

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * 0.06,
                bottom: 20,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
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
              child: Column(
                children: [
                  Consumer<ProfileProvider>(
                    builder: (context, data, _) {
                      final imageUrl =
                          data.fetchProfileState.data?.profile?.imageUrl;

                      if (imageUrl == null || imageUrl.isEmpty) {
                        // Default placeholder avatar with green theme
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      return CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.green,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF66BB6A),
                                    Color(0xFF43A047),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Attendance App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Manage your applications',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.apps, color: Color(0xFF2E7D32), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Application Section',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Applications section
            _buildDrawerItem(
              context,
              icon: Icons.business_center,
              title: "Official Application",
              subtitle: "Submit work-related requests",
              iconColor: Color(0xFF4CAF50),
              onTap: () {
                // OfficialApplicationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationListPage(),
                  ),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.beach_access,
              title: "Leave Application",
              subtitle: "Apply for time off",
              iconColor: Color(0xFF66BB6A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaveAppListPage(),
                  ),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.access_time,
              title: "Late In/Out Application",
              subtitle: "Report timing adjustments",
              iconColor: Color(0xFF43A047),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LateInEarlyOutAppListPage()),
                );
              },
            ),

            Spacer(),

            // Divider with style
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.green.shade300,
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // Logout button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFFFCDD2)),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFCDD2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFD32F2F),
                    size: 20,
                  ),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Sign out of your account",
                  style: TextStyle(color: Color(0xFFE57373), fontSize: 12),
                ),
                onTap: () async {
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color(0xFF2E7D32),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.green.shade400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
              SizedBox(width: 8),
              Text(
                'Confirm Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog first

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                );

                // Clear login state
                await LocalStorage.clearTokens();
                await LocalStorage.setRememberMe(false);

                // Close loading dialog and navigate
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}
