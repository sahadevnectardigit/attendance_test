class SalaryModel {
  int? id;
  String? salaryMonth;
  String? salaryMonthNp; // New field
  int? employeeId;
  String? employeeName;
  String? designationTitle;
  String? department;
  String? panNo;
  String? employeeSsf;
  String? basicSalary;
  String? dearnessAllowance;
  String? employerContributionSsf;
  String? employeeContributionSsf;
  String? employerContributionPf;
  String? employeeContributionPf;
  String? monthlyIncomeTax;
  String? socialSecurityTax;
  String? monthlyGross;
  String? netSalaryField;
  String? amountInWords;
  List<dynamic>? additionalEarnings;
  List<dynamic>? additionalDeductions;
  String? taxableIncome;
  List<TaxBreakdown>? taxBreakdown;
  String? totalTax;
  String? loanDeduction;
  String? advanceDeduction;
  String? paymentDate;
  String? paymentDateNp; // New field
  String? paymentMode;
  double? totalDeductions;
  String? uploadSignature;
  String? uploadStamp;
  String? approvedBy;
  String? approvedByDesignation;

  SalaryModel({
    this.id,
    this.salaryMonth,
    this.salaryMonthNp,
    this.employeeId,
    this.employeeName,
    this.designationTitle,
    this.department,
    this.panNo,
    this.employeeSsf,
    this.basicSalary,
    this.dearnessAllowance,
    this.employerContributionSsf,
    this.employeeContributionSsf,
    this.employerContributionPf,
    this.employeeContributionPf,
    this.monthlyIncomeTax,
    this.socialSecurityTax,
    this.monthlyGross,
    this.netSalaryField,
    this.amountInWords,
    this.additionalEarnings,
    this.additionalDeductions,
    this.taxableIncome,
    this.taxBreakdown,
    this.totalTax,
    this.loanDeduction,
    this.advanceDeduction,
    this.paymentDate,
    this.paymentDateNp,
    this.paymentMode,
    this.totalDeductions,
    this.uploadSignature,
    this.uploadStamp,
    this.approvedBy,
    this.approvedByDesignation,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      id: json['id'] as int?,
      salaryMonth: json['salary_month'] as String?,
      salaryMonthNp: json['salary_month_np'] as String?,
      employeeId: json['employee_id'] as int?,
      employeeName: json['employee_name'] as String?,
      designationTitle: json['designation_title'] as String?,
      department: json['department'] as String?,
      panNo: json['pan_no'] as String?,
      employeeSsf: json['employee_ssf'] as String?,
      basicSalary: json['basic_salary'] as String?,
      dearnessAllowance: json['dearness_allowance'] as String?,
      employerContributionSsf: json['employer_contribution_ssf'] as String?,
      employeeContributionSsf: json['employee_contribution_ssf'] as String?,
      employerContributionPf: json['employer_contribution_pf'] as String?,
      employeeContributionPf: json['employee_contribution_pf'] as String?,
      monthlyIncomeTax: json['monthly_income_tax'] as String?,
      socialSecurityTax: json['social_security_tax'] as String?,
      monthlyGross: json['monthly_gross'] as String?,
      netSalaryField: json['net_salary_field'] as String?,
      amountInWords: json['amount_in_words'] as String?,
      additionalEarnings: json['additional_earnings'] as List<dynamic>?,
      additionalDeductions: json['additional_deductions'] as List<dynamic>?,
      taxableIncome: json['taxable_income'] as String?,
      taxBreakdown: json['tax_breakdown'] != null
          ? (json['tax_breakdown'] as List)
                .map((item) => TaxBreakdown.fromJson(item))
                .toList()
          : null,
      totalTax: json['total_tax'] as String?,
      loanDeduction: json['loan_deduction'] as String?,
      advanceDeduction: json['advance_deduction'] as String?,
      paymentDate: json['payment_date'] as String?,
      paymentDateNp: json['payment_date_np'] as String?,
      paymentMode: json['payment_mode'] as String?,
      totalDeductions: (json['total_deductions'] as num?)?.toDouble(),
      uploadSignature: json['upload_signature'] as String?,
      uploadStamp: json['upload_stamp'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedByDesignation: json['approved_by_designation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salary_month': salaryMonth,
      'salary_month_np': salaryMonthNp,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'designation_title': designationTitle,
      'department': department,
      'pan_no': panNo,
      'employee_ssf': employeeSsf,
      'basic_salary': basicSalary,
      'dearness_allowance': dearnessAllowance,
      'employer_contribution_ssf': employerContributionSsf,
      'employee_contribution_ssf': employeeContributionSsf,
      'employer_contribution_pf': employerContributionPf,
      'employee_contribution_pf': employeeContributionPf,
      'monthly_income_tax': monthlyIncomeTax,
      'social_security_tax': socialSecurityTax,
      'monthly_gross': monthlyGross,
      'net_salary_field': netSalaryField,
      'amount_in_words': amountInWords,
      'additional_earnings': additionalEarnings,
      'additional_deductions': additionalDeductions,
      'taxable_income': taxableIncome,
      'tax_breakdown': taxBreakdown?.map((e) => e.toJson()).toList(),
      'total_tax': totalTax,
      'loan_deduction': loanDeduction,
      'advance_deduction': advanceDeduction,
      'payment_date': paymentDate,
      'payment_date_np': paymentDateNp,
      'payment_mode': paymentMode,
      'total_deductions': totalDeductions,
      'upload_signature': uploadSignature,
      'upload_stamp': uploadStamp,
      'approved_by': approvedBy,
      'approved_by_designation': approvedByDesignation,
    };
  }

  // Helper methods for easier data access
  double get basicSalaryValue => double.tryParse(basicSalary ?? '0') ?? 0;
  double get dearnessAllowanceValue =>
      double.tryParse(dearnessAllowance ?? '0') ?? 0;
  double get monthlyGrossValue => double.tryParse(monthlyGross ?? '0') ?? 0;
  double get netSalaryValue => double.tryParse(netSalaryField ?? '0') ?? 0;
  double get totalTaxValue => double.tryParse(totalTax ?? '0') ?? 0;
  double get employerPfValue =>
      double.tryParse(employerContributionPf ?? '0') ?? 0;
  double get employeePfValue =>
      double.tryParse(employeeContributionPf ?? '0') ?? 0;
  double get employerSsfValue =>
      double.tryParse(employerContributionSsf ?? '0') ?? 0;
  double get employeeSsfValue =>
      double.tryParse(employeeContributionSsf ?? '0') ?? 0;
  double get monthlyIncomeTaxValue =>
      double.tryParse(monthlyIncomeTax ?? '0') ?? 0;
  double get socialSecurityTaxValue =>
      double.tryParse(socialSecurityTax ?? '0') ?? 0;
  double get loanDeductionValue => double.tryParse(loanDeduction ?? '0') ?? 0;
  double get advanceDeductionValue =>
      double.tryParse(advanceDeduction ?? '0') ?? 0;

  // Formatted strings for display
  String get formattedBasicSalary => '\$${basicSalaryValue.toStringAsFixed(2)}';
  String get formattedDearnessAllowance =>
      '\$${dearnessAllowanceValue.toStringAsFixed(2)}';
  String get formattedMonthlyGross =>
      '\$${monthlyGrossValue.toStringAsFixed(2)}';
  String get formattedNetSalary => '\$${netSalaryValue.toStringAsFixed(2)}';
  String get formattedTotalTax => '\$${totalTaxValue.toStringAsFixed(2)}';

  // New getters for display
  String get displaySalaryMonth => salaryMonthNp?.isNotEmpty == true
      ? '$salaryMonth ($salaryMonthNp)'
      : salaryMonth ?? '';
  String get displayPaymentDate => paymentDateNp?.isNotEmpty == true
      ? '$paymentDate ($paymentDateNp)'
      : paymentDate ?? '';
}

class TaxBreakdown {
  String? taxRate;
  String? taxLiability;
  String? taxableAmount;

  TaxBreakdown({this.taxRate, this.taxLiability, this.taxableAmount});

  factory TaxBreakdown.fromJson(Map<String, dynamic> json) {
    return TaxBreakdown(
      taxRate: json['tax_rate'] as String?,
      taxLiability: json['tax_liability'] as String?,
      taxableAmount: json['taxable_amount'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tax_rate': taxRate,
      'tax_liability': taxLiability,
      'taxable_amount': taxableAmount,
    };
  }

  // Helper methods
  double get taxRateValue =>
      double.tryParse(taxRate?.replaceAll('%', '') ?? '0') ?? 0;
  double get taxLiabilityValue {
    final value =
        taxLiability?.replaceAll('Rs.', '').replaceAll(',', '').trim() ?? '0';
    return double.tryParse(value) ?? 0;
  }

  double get taxableAmountValue {
    final value =
        taxableAmount?.replaceAll('Rs.', '').replaceAll(',', '').trim() ?? '0';
    return double.tryParse(value) ?? 0;
  }

  String get formattedTaxLiability => taxLiability ?? 'Rs. 0.00';
  String get formattedTaxableAmount => taxableAmount ?? 'Rs. 0.00';
}

// class SalaryModel {
//   int? id;
//   String? salaryMonth;
//   int? employeeId;
//   String? employeeName;
//   String? designationTitle;
//   String? department;
//   String? panNo;
//   String? employeeSsf;
//   String? basicSalary;
//   String? dearnessAllowance;
//   String? employerContributionSsf;
//   String? employeeContributionSsf;
//   String? employerContributionPf;
//   String? employeeContributionPf;
//   String? monthlyIncomeTax;
//   String? socialSecurityTax;
//   String? monthlyGross;
//   String? netSalaryField;
//   String? amountInWords;
//   List<dynamic>? additionalEarnings;
//   List<dynamic>? additionalDeductions;
//   String? taxableIncome;
//   List<TaxBreakdown>? taxBreakdown;
//   String? totalTax;
//   String? loanDeduction;
//   String? advanceDeduction;
//   String? paymentDate;
//   String? paymentMode;
//   double? totalDeductions;
//   String? uploadSignature;
//   String? uploadStamp;
//   String? approvedBy;
//   String? approvedByDesignation;

//   SalaryModel({
//     this.id,
//     this.salaryMonth,
//     this.employeeId,
//     this.employeeName,
//     this.designationTitle,
//     this.department,
//     this.panNo,
//     this.employeeSsf,
//     this.basicSalary,
//     this.dearnessAllowance,
//     this.employerContributionSsf,
//     this.employeeContributionSsf,
//     this.employerContributionPf,
//     this.employeeContributionPf,
//     this.monthlyIncomeTax,
//     this.socialSecurityTax,
//     this.monthlyGross,
//     this.netSalaryField,
//     this.amountInWords,
//     this.additionalEarnings,
//     this.additionalDeductions,
//     this.taxableIncome,
//     this.taxBreakdown,
//     this.totalTax,
//     this.loanDeduction,
//     this.advanceDeduction,
//     this.paymentDate,
//     this.paymentMode,
//     this.totalDeductions,
//     this.uploadSignature,
//     this.uploadStamp,
//     this.approvedBy,
//     this.approvedByDesignation,
//   });

//   factory SalaryModel.fromJson(Map<String, dynamic> json) {
//     return SalaryModel(
//       id: json['id'] as int?,
//       salaryMonth: json['salary_month'] as String?,
//       employeeId: json['employee_id'] as int?,
//       employeeName: json['employee_name'] as String?,
//       designationTitle: json['designation_title'] as String?,
//       department: json['department'] as String?,
//       panNo: json['pan_no'] as String?,
//       employeeSsf: json['employee_ssf'] as String?,
//       basicSalary: json['basic_salary'] as String?,
//       dearnessAllowance: json['dearness_allowance'] as String?,
//       employerContributionSsf: json['employer_contribution_ssf'] as String?,
//       employeeContributionSsf: json['employee_contribution_ssf'] as String?,
//       employerContributionPf: json['employer_contribution_pf'] as String?,
//       employeeContributionPf: json['employee_contribution_pf'] as String?,
//       monthlyIncomeTax: json['monthly_income_tax'] as String?,
//       socialSecurityTax: json['social_security_tax'] as String?,
//       monthlyGross: json['monthly_gross'] as String?,
//       netSalaryField: json['net_salary_field'] as String?,
//       amountInWords: json['amount_in_words'] as String?,
//       additionalEarnings: json['additional_earnings'] as List<dynamic>?,
//       additionalDeductions: json['additional_deductions'] as List<dynamic>?,
//       taxableIncome: json['taxable_income'] as String?,
//       taxBreakdown: json['tax_breakdown'] != null
//           ? (json['tax_breakdown'] as List)
//               .map((item) => TaxBreakdown.fromJson(item))
//               .toList()
//           : null,
//       totalTax: json['total_tax'] as String?,
//       loanDeduction: json['loan_deduction'] as String?,
//       advanceDeduction: json['advance_deduction'] as String?,
//       paymentDate: json['payment_date'] as String?,
//       paymentMode: json['payment_mode'] as String?,
//       totalDeductions: (json['total_deductions'] as num?)?.toDouble(),
//       uploadSignature: json['upload_signature'] as String?,
//       uploadStamp: json['upload_stamp'] as String?,
//       approvedBy: json['approved_by'] as String?,
//       approvedByDesignation: json['approved_by_designation'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'salary_month': salaryMonth,
//       'employee_id': employeeId,
//       'employee_name': employeeName,
//       'designation_title': designationTitle,
//       'department': department,
//       'pan_no': panNo,
//       'employee_ssf': employeeSsf,
//       'basic_salary': basicSalary,
//       'dearness_allowance': dearnessAllowance,
//       'employer_contribution_ssf': employerContributionSsf,
//       'employee_contribution_ssf': employeeContributionSsf,
//       'employer_contribution_pf': employerContributionPf,
//       'employee_contribution_pf': employeeContributionPf,
//       'monthly_income_tax': monthlyIncomeTax,
//       'social_security_tax': socialSecurityTax,
//       'monthly_gross': monthlyGross,
//       'net_salary_field': netSalaryField,
//       'amount_in_words': amountInWords,
//       'additional_earnings': additionalEarnings,
//       'additional_deductions': additionalDeductions,
//       'taxable_income': taxableIncome,
//       'tax_breakdown': taxBreakdown?.map((e) => e.toJson()).toList(),
//       'total_tax': totalTax,
//       'loan_deduction': loanDeduction,
//       'advance_deduction': advanceDeduction,
//       'payment_date': paymentDate,
//       'payment_mode': paymentMode,
//       'total_deductions': totalDeductions,
//       'upload_signature': uploadSignature,
//       'upload_stamp': uploadStamp,
//       'approved_by': approvedBy,
//       'approved_by_designation': approvedByDesignation,
//     };
//   }

//   // Helper methods for easier data access
//   double get basicSalaryValue => double.tryParse(basicSalary ?? '0') ?? 0;
//   double get dearnessAllowanceValue => double.tryParse(dearnessAllowance ?? '0') ?? 0;
//   double get monthlyGrossValue => double.tryParse(monthlyGross ?? '0') ?? 0;
//   double get netSalaryValue => double.tryParse(netSalaryField ?? '0') ?? 0;
//   double get totalTaxValue => double.tryParse(totalTax ?? '0') ?? 0;
//   double get employerPfValue => double.tryParse(employerContributionPf ?? '0') ?? 0;
//   double get employeePfValue => double.tryParse(employeeContributionPf ?? '0') ?? 0;
//   double get employerSsfValue => double.tryParse(employerContributionSsf ?? '0') ?? 0;
//   double get employeeSsfValue => double.tryParse(employeeContributionSsf ?? '0') ?? 0;
//   double get monthlyIncomeTaxValue => double.tryParse(monthlyIncomeTax ?? '0') ?? 0;
//   double get socialSecurityTaxValue => double.tryParse(socialSecurityTax ?? '0') ?? 0;
//   double get loanDeductionValue => double.tryParse(loanDeduction ?? '0') ?? 0;
//   double get advanceDeductionValue => double.tryParse(advanceDeduction ?? '0') ?? 0;

//   // Formatted strings for display
//   String get formattedBasicSalary => '\$${basicSalaryValue.toStringAsFixed(2)}';
//   String get formattedDearnessAllowance => '\$${dearnessAllowanceValue.toStringAsFixed(2)}';
//   String get formattedMonthlyGross => '\$${monthlyGrossValue.toStringAsFixed(2)}';
//   String get formattedNetSalary => '\$${netSalaryValue.toStringAsFixed(2)}';
//   String get formattedTotalTax => '\$${totalTaxValue.toStringAsFixed(2)}';
// }

// class TaxBreakdown {
//   String? taxRate;
//   String? taxLiability;
//   String? taxableAmount;

//   TaxBreakdown({this.taxRate, this.taxLiability, this.taxableAmount});

//   factory TaxBreakdown.fromJson(Map<String, dynamic> json) {
//     return TaxBreakdown(
//       taxRate: json['tax_rate'] as String?,
//       taxLiability: json['tax_liability'] as String?,
//       taxableAmount: json['taxable_amount'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'tax_rate': taxRate,
//       'tax_liability': taxLiability,
//       'taxable_amount': taxableAmount,
//     };
//   }

//   // Helper methods
//   double get taxRateValue => double.tryParse(taxRate?.replaceAll('%', '') ?? '0') ?? 0;
//   double get taxLiabilityValue {
//     final value = taxLiability?.replaceAll('Rs.', '').replaceAll(',', '').trim() ?? '0';
//     return double.tryParse(value) ?? 0;
//   }
//   double get taxableAmountValue {
//     final value = taxableAmount?.replaceAll('Rs.', '').replaceAll(',', '').trim() ?? '0';
//     return double.tryParse(value) ?? 0;
//   }

//   String get formattedTaxLiability => taxLiability ?? 'Rs. 0.00';
//   String get formattedTaxableAmount => taxableAmount ?? 'Rs. 0.00';
// }
