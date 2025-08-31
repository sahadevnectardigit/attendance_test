class SalaryModel {
  int? id;
  String? salaryMonth;
  int? employeeId;
  String? employeeName;
  String? designationTitle;
  String? department;
  // Null? panNo;
  // Null? employeeSsf;
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
  // List<Null>? additionalEarnings;
  // List<Null>? additionalDeductions;
  String? taxableIncome;
  List<TaxBreakdown>? taxBreakdown;
  String? totalTax;
  // Null? paymentDate;
  // String? paymentMode;
  double? totalDeductions;
  // Null? uploadSignature;
  // Null? uploadStamp;
  // Null? approvedBy;
  // Null? approvedByDesignation;

  SalaryModel({
    this.id,
    this.salaryMonth,
    this.employeeId,
    this.employeeName,
    this.designationTitle,
    this.department,
    // this.panNo,
    // this.employeeSsf,
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
    // this.additionalEarnings,
    // this.additionalDeductions,
    this.taxableIncome,
    this.taxBreakdown,
    this.totalTax,
    // this.paymentDate,
    // this.paymentMode,
    this.totalDeductions,
    // this.uploadSignature,
    // this.uploadStamp,
    // this.approvedBy,
    // this.approvedByDesignation
  });

  SalaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salaryMonth = json['salary_month'];
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    designationTitle = json['designation_title'];
    department = json['department'];
    // panNo = json['pan_no'];
    // employeeSsf = json['employee_ssf'];
    basicSalary = json['basic_salary'];
    dearnessAllowance = json['dearness_allowance'];
    employerContributionSsf = json['employer_contribution_ssf'];
    employeeContributionSsf = json['employee_contribution_ssf'];
    employerContributionPf = json['employer_contribution_pf'];
    employeeContributionPf = json['employee_contribution_pf'];
    monthlyIncomeTax = json['monthly_income_tax'];
    socialSecurityTax = json['social_security_tax'];
    monthlyGross = json['monthly_gross'];
    netSalaryField = json['net_salary_field'];
    amountInWords = json['amount_in_words'];
    // if (json['additional_earnings'] != null) {
    //   additionalEarnings = <Null>[];
    //   json['additional_earnings'].forEach((v) {
    //     additionalEarnings!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['additional_deductions'] != null) {
    //   additionalDeductions = <Null>[];
    //   json['additional_deductions'].forEach((v) {
    //     additionalDeductions!.add(new Null.fromJson(v));
    //   });
    // }
    taxableIncome = json['taxable_income'];
    if (json['tax_breakdown'] != null) {
      taxBreakdown = <TaxBreakdown>[];
      json['tax_breakdown'].forEach((v) {
        taxBreakdown!.add(TaxBreakdown.fromJson(v));
      });
    }
    totalTax = json['total_tax'];
    // paymentDate = json['payment_date'];
    // paymentMode = json['payment_mode'];
    totalDeductions = json['total_deductions'];
    // uploadSignature = json['upload_signature'];
    // uploadStamp = json['upload_stamp'];
    // approvedBy = json['approved_by'];
    // approvedByDesignation = json['approved_by_designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salary_month'] = salaryMonth;
    data['employee_id'] = employeeId;
    data['employee_name'] = employeeName;
    data['designation_title'] = designationTitle;
    data['department'] = department;
    // data['pan_no'] = this.panNo;
    // data['employee_ssf'] = this.employeeSsf;
    data['basic_salary'] = basicSalary;
    data['dearness_allowance'] = dearnessAllowance;
    data['employer_contribution_ssf'] = employerContributionSsf;
    data['employee_contribution_ssf'] = employeeContributionSsf;
    data['employer_contribution_pf'] = employerContributionPf;
    data['employee_contribution_pf'] = employeeContributionPf;
    data['monthly_income_tax'] = monthlyIncomeTax;
    data['social_security_tax'] = socialSecurityTax;
    data['monthly_gross'] = monthlyGross;
    data['net_salary_field'] = netSalaryField;
    data['amount_in_words'] = amountInWords;
    // if (this.additionalEarnings != null) {
    //   data['additional_earnings'] =
    //       this.additionalEarnings!.map((v) => v.toJson()).toList();
    // }
    // if (this.additionalDeductions != null) {
    //   data['additional_deductions'] =
    //       this.additionalDeductions!.map((v) => v.toJson()).toList();
    // }
    data['taxable_income'] = taxableIncome;
    if (taxBreakdown != null) {
      data['tax_breakdown'] = taxBreakdown!.map((v) => v.toJson()).toList();
    }
    data['total_tax'] = totalTax;
    // data['payment_date'] = this.paymentDate;
    // data['payment_mode'] = this.paymentMode;
    data['total_deductions'] = this.totalDeductions;
    // data['upload_signature'] = this.uploadSignature;
    // data['upload_stamp'] = this.uploadStamp;
    // data['approved_by'] = this.approvedBy;
    // data['approved_by_designation'] = this.approvedByDesignation;
    return data;
  }
}

class TaxBreakdown {
  String? taxRate;
  String? taxLiability;
  String? taxableAmount;

  TaxBreakdown({this.taxRate, this.taxLiability, this.taxableAmount});

  TaxBreakdown.fromJson(Map<String, dynamic> json) {
    taxRate = json['tax_rate'];
    taxLiability = json['tax_liability'];
    taxableAmount = json['taxable_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tax_rate'] = taxRate;
    data['tax_liability'] = taxLiability;
    data['taxable_amount'] = taxableAmount;
    return data;
  }
}
