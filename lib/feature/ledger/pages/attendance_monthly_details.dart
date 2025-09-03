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
  // Green theme colors
  final List<Color> greenGradient = [Color(0xFF4CAF50), Color(0xFF2E7D32)];

  final List<Color> lightGreenGradient = [Color(0xFFE8F5E9), Color(0xFFC8E6C9)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text(
          "Monthly Detail Data",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2E7D32)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with date
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  detailData.date ?? "N/A",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(detailData.remarks),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    detailData.day ?? "N/A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          // Status indicator
                          if (detailData.remarks.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  detailData.remarks,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(
                                    detailData.remarks,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(detailData.remarks),
                                    size: 16,
                                    color: _getStatusColor(detailData.remarks),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      detailData.remarks ?? "N/A",
                                      style: TextStyle(
                                        color: _getStatusColor(
                                          detailData.remarks,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 16),

                          // Time information
                          _infoRow("Time In", detailData.timeIn, Icons.login),
                          _infoRow(
                            "Time Out",
                            detailData.timeOut,
                            Icons.logout,
                          ),

                          SizedBox(height: 8),

                          // Work hours
                          Row(
                            children: [
                              Expanded(
                                child: _metricCard(
                                  "Worked Hours",
                                  detailData.workedHour ?? "N/A",
                                  Icons.access_time,
                                  Color(0xFF2196F3),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _metricCard(
                                  "Overtime",
                                  detailData.ot ?? "N/A",
                                  Icons.timer,
                                  Color(0xFFFF9800),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10);
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
      padding: EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            "Total",
            summary.total.toString(),
            Color(0xFF2196F3),
          ),
          _buildSummaryItem(
            "Present",
            summary.present.toString(),
            Color(0xFF4CAF50),
          ),
          _buildSummaryItem(
            "Absent",
            summary.absent.toString(),
            Color(0xFFF44336),
          ),
          _buildSummaryItem(
            "Leave",
            summary.leave.toString(),
            Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF2E7D32)),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "N/A",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;

    switch (status.toLowerCase()) {
      case 'present':
        return Color(0xFF4CAF50);
      case 'absent':
        return Color(0xFFF44336);
      case 'leave':
        return Color(0xFFFF9800);
      case 'holiday':
        return Color(0xFF9C27B0);
      case 'weekend':
        return Color(0xFF607D8B);
      default:
        return Color(0xFF2196F3);
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null) return Icons.help_outline;

    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'leave':
        return Icons.beach_access;
      case 'holiday':
        return Icons.celebration;
      case 'weekend':
        return Icons.weekend;
      default:
        return Icons.help_outline;
    }
  }
}
