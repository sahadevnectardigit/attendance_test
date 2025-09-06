import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/core/provider/internet_checker.dart';
import 'package:attendance/core/provider/locale_provider.dart';
import 'package:attendance/core/services/easy_loading_config.dart';
import 'package:attendance/core/services/main_api_client.dart';
import 'package:attendance/core/widgets/loading_widget.dart';
import 'package:attendance/core/widgets/splash_page.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/feature/salary/provider/salary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

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
      // providers: AppProviders.providers,
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),

        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),

        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider()..fetchDashboardData(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider()..fetchProfileData(),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider<SalaryProvider>(
          create: (_) => SalaryProvider()..fetchSalary(),
        ),

        ChangeNotifierProvider<LedgerProvider>(
          create: (_) => LedgerProvider()
            ..fetchLedgerDataa(
              month: NepaliDateTime.now().month,
              year: NepaliDateTime.now().year,
            ),
        ),
        ChangeNotifierProvider<ApplicationProvider>(
          create: (_) => ApplicationProvider(),
        ),
      ],
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
