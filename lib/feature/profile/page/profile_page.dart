import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final model = profileProvider.profileModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              // Clear login state
              await LocalStorage.clearTokens();
              await LocalStorage.setRememberMe(false);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AttendanceLoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? Center(child: const CircularProgressIndicator())
          : profileProvider.errorMessage != null
          ? Text(profileProvider.errorMessage!)
          : Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("${model?.firstName} ${model?.lastName} "),
                  Text(model?.tempAddress ?? ""),
                ],
              ),
            ),
    );
  }
}
