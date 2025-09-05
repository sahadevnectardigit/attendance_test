import 'package:attendance/feature/dashboard/pages/applications/latein_lateout_page.dart';
import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LateInEarlyOutAppListPage extends StatefulWidget {
  const LateInEarlyOutAppListPage({super.key});

  @override
  State<LateInEarlyOutAppListPage> createState() =>
      _LateInEarlyOutAppListPageState();
}

class _LateInEarlyOutAppListPageState extends State<LateInEarlyOutAppListPage> {
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationProvider>(
        context,
        listen: false,
      ).fetchLateInAppList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appPro = context.watch<ApplicationProvider>();
    final appList = appPro.fetchLateInAppListState;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        title: const Text("Latein Earlyout Applications"),

      ),
      body: appList.isLoading
          ? Center(child: CircularProgressIndicator())
          : !appList.hasData
          ? const Center(child: Text("No applications found."))
          : ListView.builder(
              itemCount: appList.data?.length,
              itemBuilder: (context, index) {
                final app = appList.data?[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.green.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        app?.lateInOut ?? "N/A",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Applied Date: ${app?.appliedDate}"),
                          Text("From: ${app?.dateNp}"),
                          // Text("Days: ${app?.name?}"),
                          // Text("Place: ${app?.place}"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Chip(
                                label: Text(app?.currentStatus ?? "N/A"),
                                backgroundColor: _getStatusColor(
                                  app?.currentStatus ?? 'N/A',
                                ).withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: _getStatusColor(
                                    app?.currentStatus ?? "N/A",
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // trailing: const Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: Colors.green,
                      // ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LateInLateOutCreatePage()),
          );
        },
        label: Text('Create'),
      ),
    );
  }
}
