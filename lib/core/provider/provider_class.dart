import 'package:attendance/core/provider/bottom_navbar_provider.dart';
import 'package:attendance/core/provider/internet_checker.dart';
import 'package:attendance/core/provider/locale_provider.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:attendance/feature/dashboard/provider/dashboard_provider.dart';
import 'package:attendance/feature/dutyRoster/duty_roster_provider.dart';
import 'package:attendance/feature/dutyRoster/system_setting_provider.dart';
import 'package:attendance/feature/ledger/provider/ledger_provider.dart';
import 'package:attendance/feature/profile/provider/profile_provider.dart';
import 'package:attendance/feature/salary/provider/salary_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
  ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
  ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
  ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
  ChangeNotifierProvider<BottomNavProvider>(create: (_) => BottomNavProvider()),
  ChangeNotifierProvider<SalaryProvider>(create: (_) => SalaryProvider()),
  ChangeNotifierProvider<LedgerProvider>(create: (_) => LedgerProvider()),
  ChangeNotifierProvider<ApplicationProvider>(
    create: (_) => ApplicationProvider(),
  ),
  ChangeNotifierProvider<DutyRosterProvider>(
    create: (_) => DutyRosterProvider(),
  ),
  ChangeNotifierProvider<SystemSettingProvider>(
    create: (_) => SystemSettingProvider(),
  ),
];
