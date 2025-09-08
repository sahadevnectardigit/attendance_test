import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/feature/dashboard/pages/applications/latein_earlyout_applist_page.dart';
import 'package:attendance/feature/dashboard/pages/applications/leave_app_list_page.dart';
import 'package:attendance/feature/dashboard/pages/applications/official_application_list_page.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 11),
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.manageApp,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18),

            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.apps, color: Color(0xFF2E7D32), size: 22),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.appSection,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Applications section
            _buildDrawerItem(
              context,
              icon: Icons.business_center,
              title: AppLocalizations.of(context)!.offcialApplication,
              subtitle: AppLocalizations.of(context)!.submitWorkQuery,
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
              title: AppLocalizations.of(context)!.leaveApplication,
              subtitle: AppLocalizations.of(context)!.applytimeOff,
              iconColor: Color(0xFF66BB6A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaveAppListPage()),
                );
              },
            ),

            _buildDrawerItem(
              context,
              icon: Icons.access_time,
              title: AppLocalizations.of(context)!.lateInEarlyOut,
              subtitle: AppLocalizations.of(context)!.reportTimingAdjustment,
              iconColor: Color(0xFF43A047),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LateInEarlyOutAppListPage(),
                  ),
                );
              },
            ),

            // Spacer(),

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

            SizedBox(height: 5),

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
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.signOutAccount,
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
              SizedBox(width: 3),
              Text(
                AppLocalizations.of(context)!.confirmLogout,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.areusureLogout,
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
                AppLocalizations.of(context)!.cancel,
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
                // await LocalStorage.clearTokens();
                // await LocalStorage.setRememberMe(false);

                // Close loading dialog and navigate
                Navigator.of(context).pop();
                Provider.of<LoginProvider>(context, listen: false).logout();

                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                //   (Route<dynamic> route) => false,
                // );
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
                AppLocalizations.of(context)!.logout,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}
