class ApiUrl {
  static const String tattendance = "https://tattendance.com";
  static const String login = "$tattendance/api/login/";
  static const String dashboard = "$tattendance/api/employee-dashboard/";
  static const String ledger = "$tattendance/api/ledger/";
  static const String profile = "$tattendance/api/profile/";
  static const String updateProfileImage = "$tattendance/api/profile/image/";
  static const String changePassword =
      "$tattendance/api/profile/change-password/";
  static const String token = "$tattendance/api/api/token/";
  static const String refreshToken = "$tattendance/api/api/token/refresh/";
  static const String employeeSalary = "$tattendance/api/employee-salary/";

  ///application
  static const String getLeavesDropDown = "$tattendance/api/leaves";
  static const String getOfficialVisitDropDown =
      "$tattendance/api/official-visit/";
  static const String createLeaveApplication =
      "$tattendance/api/leave-applications/create/";
  static const String getApprover = "$tattendance/api/approver-dropdowns/";
  static const String lateInEarlyOut =
      "$tattendance/api/lateIn-earlyOut-applications/create/";
  static const String createOfficialVisitApplication =
      "$tattendance/api/official-visit-applications/create/";

  ///getApplications status api
  static const String getLeaveApplications =
      "$tattendance/api/leave-applications/";
  static const String getOfficialVisitApplications =
      "$tattendance/api/official-visit-applications/";
  static const String getLateInEaryOutApplications =
      "$tattendance/api/lateIn-earlyOut-applications/";
  static const String dutyRoster = "$tattendance/api/duty-roster/list/";

  static const String systemSetting = "$tattendance/api/system-settings/";
}
