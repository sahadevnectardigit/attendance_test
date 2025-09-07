import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/utils/text_form_field.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Green theme colors
  final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

  final List<Color> lightGreenGradient = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];

  @override
  void dispose() {
    super.dispose();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.changePassword,
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: lightGreenGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      AppLocalizations.of(context)!.createSecurePassword,
                      style: TextStyle(fontSize: 16, color: Color(0xFF2E7D32)),
                    ),
                  ),

                  // New Password Field
                  AppTextFormField(
                    controller: passwordController,
                    label: AppLocalizations.of(context)!.newPassword,
                    hint: AppLocalizations.of(context)!.newPassword,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixIconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 8) {
                        return 'Password must contain at least 8 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 15),

                  // Confirm Password Field
                  AppTextFormField(
                    controller: confirmPasswordController,
                    label: AppLocalizations.of(context)!.confirmPassword,
                    hint: AppLocalizations.of(context)!.confirmPassword,
                    obscureText: _obscureConfirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixIconPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 40),

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: profileProvider.changePasswordState.isLoading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;

                              final isSuccess = await profileProvider
                                  .changePassword(
                                    password: passwordController.text.trim(),
                                  );

                              if (isSuccess) {
                                context.showSnackBarMessage(
                                  message: "Password changed successfully",
                                  backgroundColor: Color(0xFF4CAF50),
                                );
                                Navigator.pop(context);
                              } else {
                                context.showSnackBarMessage(
                                  message: profileProvider
                                      .changePasswordState
                                      .error
                                      .toString(),
                                  backgroundColor: Color(0xFFF44336),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.green.withOpacity(0.3),
                      ),
                      child: profileProvider.changePasswordState.isLoading
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.changePassword,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
