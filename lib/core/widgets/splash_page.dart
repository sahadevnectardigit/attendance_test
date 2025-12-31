import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/feature/dutyRoster/system_setting_provider.dart';
import 'package:attendance/navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // If user chose remember me, validate and refresh tokens
    if (rememberMe) {
      final isTokenValid = await MainApiClient.validateAndRefreshToken();

      if (isTokenValid) {
        context.read<SystemSettingProvider>().fetchSystemSettings();
        // Token is valid or successfully refreshed, go to main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NavBarPage()),
        );
        // context.read<DutyRosterProvider>().fetchDutyRoster();
      } else {
        // Token validation/refresh failed, go to login
        await LocalStorage.clearTokens(); // Clear invalid tokens
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } else {
      // User didn't choose remember me, go to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/images/splash.svg",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuth();
//   }

//   Future<void> _checkAuth() async {
//     final rememberMe = await LocalStorage.getRememberMe();
//     final token = await LocalStorage.getAccessToken();
//     final refreshToken = await LocalStorage.getRefreshToken();

//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;

//     // Validate that tokens exist and are not empty
//     final hasValidToken = token != null && token.isNotEmpty;
//     final hasValidRefreshToken =
//         refreshToken != null && refreshToken.isNotEmpty;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => (rememberMe && hasValidToken && hasValidRefreshToken)
//             ? NavBarPage()
//             : const LoginPage(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SvgPicture.asset(
//           "assets/images/splash.svg",
//           height: double.infinity,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
