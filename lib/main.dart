import 'package:attendance/core/provider/provider_class.dart';
import 'package:attendance/core/services/easy_loading_config.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/widgets/loading_widget.dart';
import 'package:attendance/core/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

// Add this to your main.dart or a global file
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  runApp(
    GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) {
        return Center(child: LoadingWidget());
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainApiClient.navigatorKey = navigatorKey;

    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Attendance Login',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        ),
        builder: EasyLoading.init(),
        home: SplashPage(),
      ),
    );
  }
}
