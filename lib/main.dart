import 'package:attendance/core/provider/provider_class.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/pages/login_page.dart';
import 'package:attendance/navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final rememberMe = await LocalStorage.getRememberMe();
  final token = await LocalStorage.getAccessToken();

  runApp(
    MyApp(
      initialPage: (rememberMe && token != null)
          ? NavBarPage()
          : const AttendanceLoginPage(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: initialPage,
      ),
    );
  }
}
