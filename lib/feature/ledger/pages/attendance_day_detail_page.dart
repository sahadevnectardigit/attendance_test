import 'package:attendance/l10n/app_localizations.dart';
import 'package:attendance/models/ledger_model.dart';
import 'package:flutter/material.dart';

class AttendanceDayDetail extends StatelessWidget {
  final DetailData detailData;
  const AttendanceDayDetail({super.key, required this.detailData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.attendanceDayDetail),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.green.shade300),
        ),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),

            // Main container with date header
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
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
                            detailData.date,
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
                              color: _getStatusColor(detailData.overallStatus),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              detailData.day,
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

                    // Overall Status indicator
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          detailData.overallStatus,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(
                            detailData.overallStatus,
                          ).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(detailData.overallStatus),
                            size: 16,
                            color: _getStatusColor(detailData.overallStatus),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detailData.overallStatus,
                              style: TextStyle(
                                color: _getStatusColor(
                                  detailData.overallStatus,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Day status badges
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (detailData.dayHasLeave)
                          _statusBadge("Leave", Color(0xFFFF9800)),
                        if (detailData.dayHasOv)
                          _statusBadge("Official Visit", Color(0xFF9C27B0)),
                        if (detailData.dayHasHoliday)
                          _statusBadge("Holiday", Color(0xFF00BCD4)),
                        if (detailData.dayIsWeekend)
                          _statusBadge("Weekend", Color(0xFF607D8B)),
                      ],
                    ),

                    if (detailData.dayHasLeave ||
                        detailData.dayHasOv ||
                        detailData.dayHasHoliday ||
                        detailData.dayIsWeekend)
                      SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // Shifts list
            Expanded(
              child: ListView.builder(
                itemCount: detailData.shifts.length,
                itemBuilder: (context, index) {
                  final shift = detailData.shifts[index];
                  return _buildShiftCard(context, shift, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftCard(BuildContext context, ShiftData shift, int index) {
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shift header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: Color(0xFF2E7D32), size: 20),
                    SizedBox(width: 8),
                    Text(
                      shift.shiftName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                      ),
                    ),
                    if (shift.isSpecial) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE91E63),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Special",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(shift.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    shift.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Shift timing
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _shiftTimeItem("From", shift.fromTime, Icons.access_time),
                  Container(
                    width: 1,
                    height: 30,
                    color: Color(0xFF2E7D32).withOpacity(0.3),
                  ),
                  _shiftTimeItem("To", shift.toTime, Icons.access_time_filled),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Actual attendance times
            _infoRow(
              AppLocalizations.of(context)!.timeIn,
              shift.timeIn.isEmpty ? "N/A" : shift.timeIn,
              Icons.login,
            ),
            if (shift.timeRemarksIn.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 6),
                child: Text(
                  shift.timeRemarksIn,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            _infoRow(
              AppLocalizations.of(context)!.timeOut,
              shift.timeOut.isEmpty ? "N/A" : shift.timeOut,
              Icons.logout,
            ),
            if (shift.timeRemarksOut.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 6),
                child: Text(
                  shift.timeRemarksOut,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            SizedBox(height: 8),

            // Work hours metric
            _metricCard(
              AppLocalizations.of(context)!.workedHours,
              shift.workedHour.isEmpty ? "N/A" : shift.workedHour,
              Icons.access_time,
              Color(0xFF2196F3),
            ),

            // SizedBox(height: 8),

            // // Shift metadata
            // Row(
            //   children: [
            //     Expanded(
            //       child: _metadataItem("Type", shift.shiftType),
            //     ),
            //     SizedBox(width: 8),
            //     Expanded(
            //       child: _metadataItem("Source", shift.shiftSource),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _shiftTimeItem(String label, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Color(0xFF2E7D32)),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF2E7D32).withOpacity(0.7),
          ),
        ),
        SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _metadataItem(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.grey;

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
      case 'official visit':
      case 'official_visit':
        return Color(0xFF673AB7);
      default:
        return Color(0xFF2196F3);
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null || status.isEmpty) return Icons.help_outline;

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
      case 'official visit':
      case 'official_visit':
        return Icons.business_center;
      default:
        return Icons.help_outline;
    }
  }

  Widget _infoRow(String label, String value, IconData icon) {
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
              value,
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
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 10, color: color)),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class AttendacneDayDetail extends StatelessWidget {
//   final DetailData detailData;
//   const AttendacneDayDetail({super.key, required this.detailData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.green.shade100,
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.attendanceDayDetail),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(color: Colors.green.shade300),
//         ),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.green.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header with date
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFE8F5E9),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             detailData.date ?? "N/A",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2E7D32),
//                               fontSize: 16,
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _getStatusColor(detailData.remarks),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               detailData.day ?? "N/A",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 12),

//                     // Status indicator
//                     if (detailData.remarks.isNotEmpty)
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(
//                             detailData.remarks,
//                           ).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: _getStatusColor(
//                               detailData.remarks,
//                             ).withOpacity(0.3),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               _getStatusIcon(detailData.remarks),
//                               size: 16,
//                               color: _getStatusColor(detailData.remarks),
//                             ),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 detailData.remarks ?? "N/A",
//                                 style: TextStyle(
//                                   color: _getStatusColor(detailData.remarks),
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     SizedBox(height: 16),

//                     // Time information
//                     _infoRow(
//                       AppLocalizations.of(context)!.timeIn,
//                       detailData.timeIn,
//                       Icons.login,
//                     ),
//                     _infoRow(
//                       AppLocalizations.of(context)!.timeOut,
//                       detailData.timeOut,
//                       Icons.logout,
//                     ),

//                     SizedBox(height: 8),

//                     // Work hours
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _metricCard(
//                             AppLocalizations.of(context)!.workedHours,
//                             detailData.workedHour ?? "N/A",
//                             Icons.access_time,
//                             Color(0xFF2196F3),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: _metricCard(
//                             AppLocalizations.of(context)!.overtime,
//                             detailData.ot ?? "N/A",
//                             Icons.timer,
//                             Color(0xFFFF9800),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String? status) {
//     if (status == null) return Colors.grey;

//     switch (status.toLowerCase()) {
//       case 'present':
//         return Color(0xFF4CAF50);
//       case 'absent':
//         return Color(0xFFF44336);
//       case 'leave':
//         return Color(0xFFFF9800);
//       case 'holiday':
//         return Color(0xFF9C27B0);
//       case 'weekend':
//         return Color(0xFF607D8B);
//       default:
//         return Color(0xFF2196F3);
//     }
//   }

//   IconData _getStatusIcon(String? status) {
//     if (status == null) return Icons.help_outline;

//     switch (status.toLowerCase()) {
//       case 'present':
//         return Icons.check_circle;
//       case 'absent':
//         return Icons.cancel;
//       case 'leave':
//         return Icons.beach_access;
//       case 'holiday':
//         return Icons.celebration;
//       case 'weekend':
//         return Icons.weekend;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   Widget _infoRow(String label, String? value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Color(0xFF2E7D32)),
//           SizedBox(width: 10),
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Color(0xFF2E7D32),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value ?? "N/A",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _metricCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 18, color: color),
//           SizedBox(height: 5),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           SizedBox(height: 2),
//           Text(title, style: TextStyle(fontSize: 10, color: color)),
//         ],
//       ),
//     );
//   }
// }
