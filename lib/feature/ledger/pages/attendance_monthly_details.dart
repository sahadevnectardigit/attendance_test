import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class AttendanceMonthlyDetails extends StatefulWidget {
  final List<DetailData> detailData;
  final SummaryData summaryData;
  const AttendanceMonthlyDetails({
    super.key,
    required this.detailData,
    required this.summaryData,
  });

  @override
  State<AttendanceMonthlyDetails> createState() =>
      _AttendanceMonthlyDetailsState();
}

class _AttendanceMonthlyDetailsState extends State<AttendanceMonthlyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("Monthly Detail Data"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// Summary statistics
            _buildSummaryCard(widget.summaryData),

            ///Detail statistics
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemCount: widget.detailData.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final detailData = widget.detailData[index];
                  return Card(
                    color: Colors.white, //blue.shade200
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Date", detailData.date),
                          _infoRow("Day", detailData.day),
                          _infoRow("Remarks", detailData.remarks),
                          const Divider(height: 16, thickness: 1),
                          _infoRow("Time In", detailData.timeIn),
                          _infoRow("Time Out", detailData.timeOut),
                          _infoRow("Worked Hour", detailData.workedHour),
                          _infoRow("OT", detailData.ot),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 5);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(SummaryData summary) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Total", summary.total.toString(), Colors.blue),
          _buildSummaryItem(
            "Present",
            summary.present.toString(),
            Colors.green,
          ),
          _buildSummaryItem("Absent", summary.absent.toString(), Colors.red),
          _buildSummaryItem("Leave", summary.leave.toString(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            value ?? "N/A",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
