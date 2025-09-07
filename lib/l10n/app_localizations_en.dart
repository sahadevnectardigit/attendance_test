// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hey';

  @override
  String get welcome => 'Welcome to our app';

  @override
  String get home => 'Dashboard';

  @override
  String get salary => 'Salary';

  @override
  String get ledger => 'Ledger';

  @override
  String get profile => 'Profile';

  @override
  String get monthlyStat => 'Monthly Statistics';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get lateIn => 'Late in';

  @override
  String get earlyOut => 'Early out';

  @override
  String get holidays => 'Holidays';

  @override
  String get approvedLeave => 'Approved Leave';
}
