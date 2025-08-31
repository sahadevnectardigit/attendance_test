import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/utils/text_form_field.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Change password')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15),
              AppTextFormField(
                controller: passwordController,
                label: "New Password",
                hint: "Enter new password",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must contain at least 8 character';
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final isSuccess = await profileProvider.changePassword(
                    password: passwordController.text.trim(),
                  );
                  if (isSuccess) {
                    context.showSnackBarMessage(
                      message: "Password changed successfully",
                      backgroundColor: Colors.green,
                    );
                  } else {
                    context.showSnackBarMessage(
                      message: profileProvider.errorChangePassword.toString(),
                      backgroundColor: Colors.red,
                    );
                  }
                },
                child: profileProvider.isLoading
                    ? const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
