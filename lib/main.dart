import 'package:attendance/core/provider/locale_provider.dart';
import 'package:attendance/core/services/easy_loading_config.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/widgets/loading_widget.dart';
import 'package:attendance/core/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'core/provider/provider_class.dart';
import 'l10n/app_localizations.dart'; // auto-generated

// Add this to your main.dart or a global file
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();

  runApp(
    MultiProvider(
      providers: providers,
      child: GlobalLoaderOverlay(
        overlayWidgetBuilder: (_) => const Center(child: LoadingWidget()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainApiClient.navigatorKey = navigatorKey;

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Attendance Login',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
            useMaterial3: true,
          ),
          builder: EasyLoading.init(),
          home: const SplashPage(),
        );
      },
    );
  }
}
