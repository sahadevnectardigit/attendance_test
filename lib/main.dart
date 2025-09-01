import 'package:attendance/core/provider/provider_class.dart';
import 'package:attendance/core/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Add this to your main.dart or a global file
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Attendance Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade50),
        ),
        home: SplashPage(),
      ),
    );
  }
}