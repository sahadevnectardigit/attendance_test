import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hey'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your account'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterCompanyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter company code'**
  String get enterCompanyCode;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @companyCode.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get companyCode;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Attendance App'**
  String get appName;

  /// No description provided for @manageApp.
  ///
  /// In en, this message translates to:
  /// **'Manage your applications'**
  String get manageApp;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'Application Section'**
  String get appSection;

  /// No description provided for @offcialApplication.
  ///
  /// In en, this message translates to:
  /// **'Official Application'**
  String get offcialApplication;

  /// No description provided for @submitWorkQuery.
  ///
  /// In en, this message translates to:
  /// **'Submit work related requests'**
  String get submitWorkQuery;

  /// No description provided for @leaveApplication.
  ///
  /// In en, this message translates to:
  /// **'Leave Application'**
  String get leaveApplication;

  /// No description provided for @applytimeOff.
  ///
  /// In en, this message translates to:
  /// **'Apply for time off'**
  String get applytimeOff;

  /// No description provided for @lateInEarlyOut.
  ///
  /// In en, this message translates to:
  /// **'Late In Early Out Application'**
  String get lateInEarlyOut;

  /// No description provided for @reportTimingAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Report timing adjustment'**
  String get reportTimingAdjustment;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get home;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @monthlyStat.
  ///
  /// In en, this message translates to:
  /// **'Monthly Statistics'**
  String get monthlyStat;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @lateIn.
  ///
  /// In en, this message translates to:
  /// **'Late in'**
  String get lateIn;

  /// No description provided for @earlyOut.
  ///
  /// In en, this message translates to:
  /// **'Early out'**
  String get earlyOut;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidays;

  /// No description provided for @approvedLeave.
  ///
  /// In en, this message translates to:
  /// **'Approved Leave'**
  String get approvedLeave;

  /// No description provided for @salarySlips.
  ///
  /// In en, this message translates to:
  /// **'Salary Slips'**
  String get salarySlips;

  /// No description provided for @totalRecords.
  ///
  /// In en, this message translates to:
  /// **'Total Records'**
  String get totalRecords;

  /// No description provided for @salaryHistory.
  ///
  /// In en, this message translates to:
  /// **'Salary History'**
  String get salaryHistory;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @netSalary.
  ///
  /// In en, this message translates to:
  /// **'Net Salary'**
  String get netSalary;

  /// No description provided for @attendanceLedger.
  ///
  /// In en, this message translates to:
  /// **'Attendance Ledger'**
  String get attendanceLedger;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @attendanceDayDetail.
  ///
  /// In en, this message translates to:
  /// **'Attendance Day Detail'**
  String get attendanceDayDetail;

  /// No description provided for @timeIn.
  ///
  /// In en, this message translates to:
  /// **'Time In'**
  String get timeIn;

  /// No description provided for @timeOut.
  ///
  /// In en, this message translates to:
  /// **'Time Out'**
  String get timeOut;

  /// No description provided for @workedHours.
  ///
  /// In en, this message translates to:
  /// **'Worked Hours'**
  String get workedHours;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSetting;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectLanguage;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get updatePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @areusureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areusureLogout;

  /// No description provided for @signOutAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get signOutAccount;

  /// No description provided for @createSecurePassword.
  ///
  /// In en, this message translates to:
  /// **'Create a new secure password'**
  String get createSecurePassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @employeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Employee Details'**
  String get employeeDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @employeId.
  ///
  /// In en, this message translates to:
  /// **'Employee Id'**
  String get employeId;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designaion'**
  String get designation;

  /// No description provided for @panNo.
  ///
  /// In en, this message translates to:
  /// **'PAN No'**
  String get panNo;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @basicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary'**
  String get basicSalary;

  /// No description provided for @dearnessAllowance.
  ///
  /// In en, this message translates to:
  /// **'Dearness Allowance'**
  String get dearnessAllowance;

  /// No description provided for @grossSalary.
  ///
  /// In en, this message translates to:
  /// **'Gross Salary'**
  String get grossSalary;

  /// No description provided for @deductions.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get deductions;

  /// No description provided for @employerPf.
  ///
  /// In en, this message translates to:
  /// **'Employer PF'**
  String get employerPf;

  /// No description provided for @employeePf.
  ///
  /// In en, this message translates to:
  /// **'Employee PF'**
  String get employeePf;

  /// No description provided for @employerSsf.
  ///
  /// In en, this message translates to:
  /// **'Employer SSF'**
  String get employerSsf;

  /// No description provided for @employeeSsf.
  ///
  /// In en, this message translates to:
  /// **'Employee SSF'**
  String get employeeSsf;

  /// No description provided for @incomeTax.
  ///
  /// In en, this message translates to:
  /// **'Income Tax'**
  String get incomeTax;

  /// No description provided for @socialSecurityTax.
  ///
  /// In en, this message translates to:
  /// **'Social Security Tax'**
  String get socialSecurityTax;

  /// No description provided for @loanDeduction.
  ///
  /// In en, this message translates to:
  /// **'Loan Deduction'**
  String get loanDeduction;

  /// No description provided for @advanceDeduction.
  ///
  /// In en, this message translates to:
  /// **'Advance Deduction'**
  String get advanceDeduction;

  /// No description provided for @totalDeduction.
  ///
  /// In en, this message translates to:
  /// **'Total Deductions'**
  String get totalDeduction;

  /// No description provided for @taxBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Tax Breakdown'**
  String get taxBreakdown;

  /// No description provided for @totalTax.
  ///
  /// In en, this message translates to:
  /// **'Total Tax'**
  String get totalTax;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @taxableIncome.
  ///
  /// In en, this message translates to:
  /// **'Taxable Income'**
  String get taxableIncome;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentMode;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ne': return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
