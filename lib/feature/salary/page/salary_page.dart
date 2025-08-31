import 'package:attendance/feature/salary/page/salary_details.dart';
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
    final data = provider.salaryList;

    return Scaffold(
      appBar: AppBar(title: const Text('Salary Slip'), centerTitle: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null || data.isEmpty
          ? const Center(child: Text("No salary data available"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final modelData = data[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SalaryDetails(data: modelData),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        modelData.salaryMonth ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Name: ${modelData.employeeName ?? "-"}"),
                          Text("Department: ${modelData.department ?? "-"}"),
                          Text(
                            "Net Salary: ${modelData.netSalaryField ?? "-"}",
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
