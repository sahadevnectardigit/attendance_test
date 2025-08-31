import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/feature/salary/provider/salary_provider.dart';
import 'package:provider/provider.dart';

class AppProviders {
  /// Returns a list of all providers in the app
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
    ChangeNotifierProvider<ProfileProvider>(
      create: (_) => ProfileProvider()..fetchProfileData(),
    ),

    ChangeNotifierProvider<DashboardProvider>(
      create: (_) => DashboardProvider(),
    ),
    ChangeNotifierProvider<BottomNavProvider>(
      create: (_) => BottomNavProvider(),
    ),
    ChangeNotifierProvider<LedgerProvider>(create: (_) => LedgerProvider()),
    ChangeNotifierProvider<SalaryProvider>(
      create: (_) => SalaryProvider()..fetchSalary(),
    ),
  ];
}
