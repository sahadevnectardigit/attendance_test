import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/extension/string_validators.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/core/utils/text_form_field.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceLoginPage extends StatefulWidget {
  const AttendanceLoginPage({super.key});

  @override
  State<AttendanceLoginPage> createState() => _AttendanceLoginPageState();
}

class _AttendanceLoginPageState extends State<AttendanceLoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "sahadev@gmail.com");
  final companyCodeController = TextEditingController(text: "pa111");
  final passwordController = TextEditingController(text: "admin@admin");
  bool rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              AppTextFormField(
                controller: emailController,
                label: "Email",
                hint: "Email Address",
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value.validateEmail(),
              ),

              const SizedBox(height: 16),
              AppTextFormField(
                controller: companyCodeController,
                label: "Company Code",
                hint: "Enter Company Code",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your company code";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              AppTextFormField(
                controller: passwordController,
                label: "Password",
                hint: "Enter Password",
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () {},
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text("Remember Me"),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loginProvider.isLoading ? null : _handleLogin,
                  child: loginProvider.isLoading
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final loginProvider = context.read<LoginProvider>();

    final success = await loginProvider.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      companyCode: companyCodeController.text.trim(),
    );

    if (success) {
      await LocalStorage.setRememberMe(rememberMe);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavBarPage()),
        (Route<dynamic> route) => false,
      );
      context.showSnackBarMessage(
        message: "Login successful!!",
        backgroundColor: Colors.green.shade600,
      );
    } else {
      context.showSnackBarMessage(
        message: loginProvider.errorMessage ?? "Login failed",
        backgroundColor: Colors.red.shade600,
      );
    }
  }
}
