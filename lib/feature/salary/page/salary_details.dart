import 'package:attendance/models/salary_model.dart';
import 'package:flutter/material.dart';

class SalaryDetails extends StatefulWidget {
  final SalaryModel? data;
  const SalaryDetails({super.key, this.data});

  @override
  State<SalaryDetails> createState() => _SalaryDetailsState();
}

class _SalaryDetailsState extends State<SalaryDetails> {
  // Green theme colors
  final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

  final List<Color> lightGreenGradient = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text(
          '${widget.data?.salaryMonth ?? ""} Salary',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: lightGreenGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Employee Info
              _buildInfoCard(
                title: "Employee Details",
                icon: Icons.person_outline,
                children: [
                  _infoRow(
                    "Name",
                    widget.data?.employeeName ?? "",
                    Icons.person,
                  ),
                  _infoRow(
                    "Employee ID",
                    widget.data?.employeeId?.toString(),
                    Icons.badge,
                  ),
                  _infoRow(
                    "Department",
                    widget.data?.department,
                    Icons.business,
                  ),
                  _infoRow(
                    "Designation",
                    widget.data?.designationTitle,
                    Icons.work_outline,
                  ),
                  _infoRow(
                    "PAN No",
                    widget.data?.panNo ?? "N/A",
                    Icons.credit_card,
                  ),
                  _infoRow(
                    "Month",
                    widget.data?.salaryMonth,
                    Icons.calendar_today,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Earnings Section
              _buildInfoCard(
                title: "Earnings",
                icon: Icons.trending_up,
                children: [
                  _infoRow(
                    "Basic Salary",
                    widget.data?.basicSalary,
                    Icons.account_balance_wallet,
                  ),
                  _infoRow(
                    "Dearness Allowance",
                    widget.data?.dearnessAllowance,
                    Icons.attach_money,
                  ),
                  _infoRow(
                    "Gross Salary",
                    widget.data?.monthlyGross,
                    Icons.account_balance,
                    isHighlight: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Deductions Section
              _buildInfoCard(
                title: "Deductions",
                icon: Icons.trending_down,
                children: [
                  // PF Contributions
                  _infoRow(
                    "Employer PF",
                    widget.data?.employerContributionPf,
                    Icons.account_balance_wallet,
                  ),
                  _infoRow(
                    "Employee PF",
                    widget.data?.employeeContributionPf,
                    Icons.account_balance_wallet,
                  ),

                  // SSF Contributions
                  _infoRow(
                    "Employer SSF",
                    widget.data?.employerContributionSsf ?? "0.00",
                    Icons.security,
                  ),
                  _infoRow(
                    "Employee SSF",
                    widget.data?.employeeSsf ?? "0.00",
                    Icons.security,
                  ),

                  // Taxes
                  _infoRow(
                    "Income Tax",
                    widget.data?.monthlyIncomeTax,
                    Icons.receipt,
                  ),
                  _infoRow(
                    "Social Security Tax",
                    widget.data?.socialSecurityTax ?? "0.00",
                    Icons.security,
                  ),

                  // Other deductions
                  _infoRow(
                    "Loan Deduction",
                    widget.data?.loanDeduction ?? "0.00",
                    Icons.money_off,
                  ),
                  _infoRow(
                    "Advance Deduction",
                    widget.data?.advanceDeduction ?? "0.00",
                    Icons.money_off,
                  ),

                  const Divider(height: 20),
                  _infoRow(
                    "Total Deductions",
                    widget.data?.totalDeductions?.toStringAsFixed(2),
                    Icons.calculate,
                    isHighlight: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Net Salary Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: greenGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Net Salary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.data?.netSalaryField ?? "0.00",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "(${widget.data?.amountInWords ?? ""})",
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.9),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tax Breakdown
              if (widget.data?.taxBreakdown != null &&
                  widget.data!.taxBreakdown!.isNotEmpty)
                _buildInfoCard(
                  title: "Tax Breakdown",
                  icon: Icons.receipt_long,
                  children: [
                    ...widget.data!.taxBreakdown!.map(
                      (tax) => _infoRow(
                        "${tax.taxRate} Tax",
                        "${tax.taxLiability} (on ${tax.taxableAmount})",
                        Icons.percent,
                      ),
                    ),
                    const Divider(height: 20),
                    _infoRow(
                      "Total Tax",
                      widget.data?.totalTax,
                      Icons.calculate,
                      isHighlight: true,
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              // Additional Information
              _buildInfoCard(
                title: "Additional Information",
                icon: Icons.info_outline,
                children: [
                  _infoRow(
                    "Taxable Income",
                    widget.data?.taxableIncome,
                    Icons.attach_money,
                  ),
                  if (widget.data?.paymentDate != null)
                    _infoRow(
                      "Payment Date",
                      widget.data?.paymentDate,
                      Icons.date_range,
                    ),
                  _infoRow(
                    "Payment Mode",
                    widget.data?.paymentMode ?? "N/A",
                    Icons.payment,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF4CAF50), size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String? value,
    IconData icon, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF4CAF50)),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? "-",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                fontSize: isHighlight ? 16 : 14,
                color: isHighlight ? Color(0xFF4CAF50) : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
