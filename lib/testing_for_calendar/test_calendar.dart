import 'package:flutter/material.dart';


class AttendanceData {
  final String date;
  final String day;
  final String timeIn;
  final String timeOut;
  final String timeRemarksIn;
  final String timeRemarksOut;
  final String workedHour;
  final String ot;
  final String remarks;

  AttendanceData({
    required this.date,
    required this.day,
    required this.timeIn,
    required this.timeOut,
    required this.timeRemarksIn,
    required this.timeRemarksOut,
    required this.workedHour,
    required this.ot,
    required this.remarks,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      timeIn: json['time_in'] ?? '',
      timeOut: json['time_out'] ?? '',
      timeRemarksIn: json['time_remarks_in'] ?? '',
      timeRemarksOut: json['time_remarks_out'] ?? '',
      workedHour: json['worked_hour'] ?? '',
      ot: json['ot'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}

class AttendanceCalendarScreen extends StatefulWidget {
  @override
  _AttendanceCalendarScreenState createState() => _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen> {
  int selectedYear = 2082;
  int selectedMonth = 3; // Chaitra (March equivalent)
  
  // Nepali month names
  final List<String> nepaliMonths = [
    'बैशाख', 'जेठ', 'असार', 'साउन', 'भाद्र', 'आश्विन',
    'कार्तिक', 'मंसिर', 'पुष', 'माघ', 'फाल्गुन', 'चैत्र'
  ];

  // Nepali day names
  final List<String> nepaliDays = [
    'आइत', 'सोम', 'मंगल', 'बुध', 'बिहि', 'शुक्र', 'शनि'
  ];

  // Nepali numerals
  final List<String> nepaliNumerals = [
    '०', '१', '२', '३', '४', '५', '६', '७', '८', '९'
  ];

  // Dummy attendance data for testing
  Map<String, AttendanceData> attendanceData = {};

  @override
  void initState() {
    super.initState();
    generateDummyData();
  }

  void generateDummyData() {
    // Generate dummy data for the month (32 days for Chaitra)
    final List<String> statuses = ['Present', 'Absent', 'Leave', 'Holiday'];
    
    for (int day = 1; day <= 32; day++) {
      String dateKey = '2082/03/${day.toString().padLeft(2, '0')}';
      String dayOfWeek = nepaliDays[(day - 1) % 7]; // Simple calculation for demo
      
      // Generate random status for demo
      String status;
      if (day % 7 == 0 || day % 7 == 6) { // Weekend
        status = day % 3 == 0 ? 'Present' : 'Absent';
      } else {
        status = day % 4 == 0 ? 'Absent' : (day % 8 == 0 ? 'Leave' : 'Present');
      }

      attendanceData[dateKey] = AttendanceData(
        date: dateKey,
        day: dayOfWeek,
        timeIn: status == 'Present' ? '09:00' : '',
        timeOut: status == 'Present' ? '17:00' : '',
        timeRemarksIn: status == 'Present' ? 'On Time' : 'Missed Punch',
        timeRemarksOut: status == 'Present' ? 'On Time' : 'Missed Punch',
        workedHour: status == 'Present' ? '8:00' : '',
        ot: status == 'Present' ? '0:00' : '',
        remarks: status,
      );
    }
  }

  String convertToNepaliNumeral(int number) {
    return number.toString().split('').map((digit) {
      return nepaliNumerals[int.parse(digit)];
    }).join('');
  }

  Color getAttendanceColor(String remarks) {
    switch (remarks.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.orange;
      case 'holiday':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget buildCalendarDay(int day) {
    String dateKey = '2082/03/${day.toString().padLeft(2, '0')}';
    AttendanceData? data = attendanceData[dateKey];
    
    Color bgColor = data != null ? getAttendanceColor(data.remarks) : Colors.grey[300]!;
    Color textColor = data != null && data.remarks.toLowerCase() != 'absent' 
        ? Colors.white 
        : Colors.white;

    return GestureDetector(
      onTap: () {
        if (data != null) {
          showAttendanceDetails(data);
        }
      },
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                convertToNepaliNumeral(day),
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (data != null)
                Text(
                  data.day,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showAttendanceDetails(AttendanceData data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('उपस्थिति विवरण - ${data.date}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('दिन: ${data.day}'),
              SizedBox(height: 8),
              Text('आगमन समय: ${data.timeIn.isEmpty ? 'N/A' : data.timeIn}'),
              Text('प्रस्थान समय: ${data.timeOut.isEmpty ? 'N/A' : data.timeOut}'),
              SizedBox(height: 8),
              Text('काम गरेको समय: ${data.workedHour.isEmpty ? 'N/A' : data.workedHour}'),
              Text('ओभरटाइम: ${data.ot.isEmpty ? 'N/A' : data.ot}'),
              SizedBox(height: 8),
              Text(
                'स्थिति: ${data.remarks}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getAttendanceColor(data.remarks),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('बन्द गर्नुहोस्'),
            ),
          ],
        );
      },
    );
  }

  Widget buildSummaryCard() {
    int totalDays = attendanceData.length;
    int presentDays = attendanceData.values.where((data) => data.remarks == 'Present').length;
    int absentDays = attendanceData.values.where((data) => data.remarks == 'Absent').length;
    int leaveDays = attendanceData.values.where((data) => data.remarks == 'Leave').length;

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'उपस्थिति सारांश',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('कुल दिन', totalDays, Colors.blue),
                _buildSummaryItem('उपस्थित', presentDays, Colors.green),
                _buildSummaryItem('अनुपस्थित', absentDays, Colors.red),
                _buildSummaryItem('बिदा', leaveDays, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          convertToNepaliNumeral(count),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('नेपाली क्यालेन्डर उपस्थिति'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Month and Year Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (selectedMonth > 1) {
                        selectedMonth--;
                      } else {
                        selectedMonth = 12;
                        selectedYear--;
                      }
                      generateDummyData(); // Generate new dummy data for different month
                    });
                  },
                  icon: Icon(Icons.chevron_left),
                ),
                Text(
                  '${nepaliMonths[selectedMonth - 1]} ${convertToNepaliNumeral(selectedYear)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (selectedMonth < 12) {
                        selectedMonth++;
                      } else {
                        selectedMonth = 1;
                        selectedYear++;
                      }
                      generateDummyData(); // Generate new dummy data for different month
                    });
                  },
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // Summary Card
          buildSummaryCard(),
          
          // Legend
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('उपस्थित', Colors.green),
                _buildLegendItem('अनुपस्थित', Colors.red),
                _buildLegendItem('बिदा', Colors.orange),
                _buildLegendItem('छुट्टी', Colors.blue),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Calendar Grid
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: getDaysInMonth(),
                itemBuilder: (context, index) {
                  return buildCalendarDay(index + 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  int getDaysInMonth() {
    // Nepali months have different number of days
    // This is a simplified version - in real app, you'd use proper Nepali calendar library
    Map<int, int> monthDays = {
      1: 31, 2: 32, 3: 32, 4: 32, 5: 32, 6: 31,
      7: 30, 8: 29, 9: 30, 10: 29, 11: 30, 12: 30
    };
    return monthDays[selectedMonth] ?? 30;
  }
}

// Additional widgets and utilities for better functionality

class AttendanceService {
  static Map<String, dynamic> sampleAttendanceJson = {
    "summary": {
      "Total": 32,
      "Present": 24,
      "Absent": 6,
      "Leave": 2,
      "Official Visit": 0,
      "Holiday": 0,
      "Weekend": 8,
      "LateIn": 3,
      "EarlyOut": 1
    },
    "detail_data": [
      {
        "date": "2082/03/01",
        "day": "आइतबार",
        "time_in": "09:00",
        "time_out": "17:00",
        "time_remarks_in": "On Time",
        "time_remarks_out": "On Time",
        "worked_hour": "8:00",
        "ot": "0:00",
        "remarks": "Present"
      },
      {
        "date": "2082/03/02",
        "day": "सोमबार",
        "time_in": "",
        "time_out": "",
        "time_remarks_in": "Missed Punch",
        "time_remarks_out": "Missed Punch",
        "worked_hour": "",
        "ot": "",
        "remarks": "Absent"
      },
      {
        "date": "2082/03/03",
        "day": "मंगलबार",
        "time_in": "09:15",
        "time_out": "17:00",
        "time_remarks_in": "Late",
        "time_remarks_out": "On Time",
        "worked_hour": "7:45",
        "ot": "0:00",
        "remarks": "Present"
      },
      // Add more dummy data...
    ]
  };

  static List<AttendanceData> parseAttendanceData(Map<String, dynamic> json) {
    List<AttendanceData> attendanceList = [];
    
    if (json['detail_data'] != null) {
      for (var item in json['detail_data']) {
        attendanceList.add(AttendanceData.fromJson(item));
      }
    }
    
    return attendanceList;
  }
}

// Enhanced Calendar Widget with better features
class EnhancedAttendanceCalendar extends StatefulWidget {
  final Map<String, AttendanceData> attendanceData;
  final String selectedMonthName;
  final int selectedYear;

  EnhancedAttendanceCalendar({
    required this.attendanceData,
    required this.selectedMonthName,
    required this.selectedYear,
  });

  @override
  _EnhancedAttendanceCalendarState createState() => _EnhancedAttendanceCalendarState();
}

class _EnhancedAttendanceCalendarState extends State<EnhancedAttendanceCalendar> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '${widget.selectedMonthName} ${_convertToNepaliNumeral(widget.selectedYear)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 16),
              _buildWeekHeader(),
              SizedBox(height: 8),
              _buildCalendarGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    final List<String> weekDays = ['आइत', 'सोम', 'मंगल', 'बुध', 'बिहि', 'शुक्र', 'शनि'];
    
    return Row(
      children: weekDays.map((day) => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 32, // Chaitra has 32 days
      itemBuilder: (context, index) {
        return _buildCalendarDay(index + 1);
      },
    );
  }

  Widget _buildCalendarDay(int day) {
    String dateKey = '2082/03/${day.toString().padLeft(2, '0')}';
    AttendanceData? data = widget.attendanceData[dateKey];
    
    Color bgColor = data != null ? _getAttendanceColor(data.remarks) : Colors.grey[200]!;
    Color textColor = Colors.white;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: data != null ? [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (data != null) {
              _showAttendanceDetails(data);
            }
          },
          child: Center(
            child: Text(
              _convertToNepaliNumeral(day),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAttendanceColor(String remarks) {
    switch (remarks.toLowerCase()) {
      case 'present':
        return Colors.green[600]!;
      case 'absent':
        return Colors.red[600]!;
      case 'leave':
        return Colors.orange[600]!;
      case 'holiday':
        return Colors.blue[600]!;
      default:
        return Colors.grey[400]!;
    }
  }

  String _convertToNepaliNumeral(int number) {
    final List<String> nepaliNumerals = [
      '०', '१', '२', '३', '४', '५', '६', '७', '८', '९'
    ];
    return number.toString().split('').map((digit) {
      return nepaliNumerals[int.parse(digit)];
    }).join('');
  }

  void _showAttendanceDetails(AttendanceData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'उपस्थिति विवरण',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('मिति', data.date),
            _buildDetailRow('दिन', data.day),
            _buildDetailRow('आगमन समय', data.timeIn.isEmpty ? 'N/A' : data.timeIn),
            _buildDetailRow('प्रस्थान समय', data.timeOut.isEmpty ? 'N/A' : data.timeOut),
            _buildDetailRow('काम गरेको समय', data.workedHour.isEmpty ? 'N/A' : data.workedHour),
            _buildDetailRow('ओभरटाइम', data.ot.isEmpty ? 'N/A' : data.ot),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getAttendanceColor(data.remarks).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getAttendanceColor(data.remarks)),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(data.remarks),
                    color: _getAttendanceColor(data.remarks),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'स्थिति: ${data.remarks}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAttendanceColor(data.remarks),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('बन्द गर्नुहोस्'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String remarks) {
    switch (remarks.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'leave':
        return Icons.event_busy;
      case 'holiday':
        return Icons.celebration;
      default:
        return Icons.help;
    }
  }
}