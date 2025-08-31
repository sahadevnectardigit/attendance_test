import 'dart:io';

import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/feature/profile/page/change_password.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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
          // IconButton(
          //   onPressed: () async {
          //     await LocalStorage.clearTokens();
          //     await LocalStorage.setRememberMe(false);

          //     Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => AttendanceLoginPage()),
          //       (Route<dynamic> route) => false,
          //     );
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.errorMessage != null
          ? Center(child: Text(profileProvider.errorMessage!))
          : Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _pickImage();

                      final success = await profileProvider.updateProfileImagge(
                        imageFile: _selectedImage,
                      );
                      if (success) {
                        context.showSnackBarMessage(
                          message: 'Profile upated successfully',
                          backgroundColor: Colors.green,
                        );
                      } else {
                        context.showSnackBarMessage(
                          message: profileProvider.errorProfileUpdate
                              .toString(),
                          backgroundColor: Colors.green,
                        );
                      }
                    },
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              model?.profile?.imageUrl?.toString() ??
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${model?.firstName ?? "Unknown"} ${model?.lastName ?? ""}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(model?.tempAddress ?? "Address"),
                  ListTile(
                    // leading: Icon(Icons.lock_outline),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    trailing: Icon(Icons.logout, size: 16),
                    onTap: () async {
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
                  ),
                ],
              ),
            ),
    );
  }
}
