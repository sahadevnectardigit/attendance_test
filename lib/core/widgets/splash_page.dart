import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/navbar_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final rememberMe = await LocalStorage.getRememberMe();
    final token = await LocalStorage.getAccessToken();
    final refreshToken = await LocalStorage.getRefreshToken();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Validate that tokens exist and are not empty
    final hasValidToken = token != null && token.isNotEmpty;
    final hasValidRefreshToken =
        refreshToken != null && refreshToken.isNotEmpty;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => (rememberMe && hasValidToken && hasValidRefreshToken)
            ? NavBarPage()
            : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_image.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
