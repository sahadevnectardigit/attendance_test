import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/core/provider/internet_checker.dart';
import 'package:attendance/core/provider/locale_provider.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/feature/salary/provider/salary_provider.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

class AppProviders {
  /// Returns a list of all providers in the app
  static List<ChangeNotifierProvider> get providers => [
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
  ];
}
