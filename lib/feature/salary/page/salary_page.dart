import 'package:attendance/feature/salary/provider/salary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalaryProvider>();
    final data = provider.salaryModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Salary Slip'), centerTitle: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text("No salary data available"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Employee Info
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Employee Details",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _infoRow("Name", data.employeeName),
                          _infoRow("Department", data.department),
                          _infoRow("Month", data.salaryMonth),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Salary Summary
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Salary Summary",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _infoRow("Basic Salary", data.basicSalary),
                          _infoRow("Allowance", data.dearnessAllowance),
                          _infoRow("Gross Salary", data.monthlyGross),
                          _infoRow(
                            "Total Deductions",
                            data.totalDeductions.toString(),
                          ),
                          const Divider(),
                          _infoRow(
                            "Net Salary",
                            data.netSalaryField,
                            isHighlight: true,
                          ),
                          Text(
                            "(${data.amountInWords})",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tax Breakdown
                  if (data.taxBreakdown != null &&
                      data.taxBreakdown!.isNotEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tax Breakdown",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...data.taxBreakdown!.map(
                              (tax) => _infoRow(
                                tax.taxRate ?? "",
                                "${tax.taxLiability} (on ${tax.taxableAmount})",
                              ),
                            ),
                            const Divider(),
                            _infoRow(
                              "Total Tax",
                              data.totalTax,
                              isHighlight: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String? value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value ?? "-",
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight ? Colors.green[700] : null,
            ),
          ),
        ],
      ),
    );
  }
}
