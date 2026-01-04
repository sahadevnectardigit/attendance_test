// {
//    "person":"Nectar Admin",
//    "summary":{
//       "Total":27,
//       "Present":0,
//       "Absent":27,
//       "Leave":0,
//       "Official_Visit":0,
//       "Holiday":0,
//       "Weekend":4,
//       "Special_Days":0,
//       "LateIn":0,
//       "EarlyOut":0
//    },
//    "detail_data":[
//       {
//          "date":"2025-12-01",
//          "day":"Monday",
//          "shifts":[
//             {
//                "shift_name":"Default Shift",
//                "shift_type":"default",
//                "shift_source":"default",
//                "from_time":"10:00:00",
//                "to_time":"18:00:00",
//                "time_in":"",
//                "time_out":"",
//                "time_remarks_in":"",
//                "time_remarks_out":"",
//                "worked_hour":"",
//                "is_special":false,
//                "shift_index":0,
//                "status":"Absent"
//             }
//          ],
//          "has_multiple_shifts":false,
//          "day_has_leave":false,
//          "day_has_ov":false,
//          "day_has_holiday":false,
//          "day_is_weekend":false,
//          "company_weekends":[
//             "saturday"
//          ],
//          "overall_status":"Absent"
//       },
//       {
//          "date":"2025-12-02",
//          "day":"Tuesday",
//          "shifts":[
//             {
//                "shift_name":"Default Shift",
//                "shift_type":"default",
//                "shift_source":"default",
//                "from_time":"10:00:00",
//                "to_time":"18:00:00",
//                "time_in":"",
//                "time_out":"",
//                "time_remarks_in":"",
//                "time_remarks_out":"",
//                "worked_hour":"",
//                "is_special":false,
//                "shift_index":0,
//                "status":"Absent"
//             }
//          ],
//          "has_multiple_shifts":false,
//          "day_has_leave":false,
//          "day_has_ov":false,
//          "day_has_holiday":false,
//          "day_is_weekend":false,
//          "company_weekends":[
//             "saturday"
//          ],
//          "overall_status":"Absent"
//       }
//         ],
//    "enable_nepali_date":false
// }
// ///...............................................................................//

// {
//    "person":"Nectar Admin",
//    "summary":{
//       "Total":27,
//       "Present":0,
//       "Absent":27,
//       "Leave":0,
//       "Official_Visit":0,
//       "Holiday":0,
//       "Weekend":4,
//       "Special_Days":0,
//       "LateIn":0,
//       "EarlyOut":0
//    },
//    "detail_data":[
//       {
//          "date":"2082/06/01",
//          "day":"Wednesday",
//          "shifts":[
//             {
//                "shift_name":"Default Shift",
//                "shift_type":"default",
//                "shift_source":"default",
//                "from_time":"10:00:00",
//                "to_time":"18:00:00",
//                "time_in":"",
//                "time_out":"",
//                "time_remarks_in":"",
//                "time_remarks_out":"",
//                "worked_hour":"",
//                "is_special":false,
//                "shift_index":0,
//                "status":"Absent"
//             }
//          ],
//          "has_multiple_shifts":false,
//          "day_has_leave":false,
//          "day_has_ov":false,
//          "day_has_holiday":false,
//          "day_is_weekend":false,
//          "company_weekends":[
//             "saturday"
//          ],
//          "overall_status":"Absent"
//       },
//       {
//          "date":"2082/06/02",
//          "day":"Thursday",
//          "shifts":[
//             {
//                "shift_name":"Default Shift",
//                "shift_type":"default",
//                "shift_source":"default",
//                "from_time":"10:00:00",
//                "to_time":"18:00:00",
//                "time_in":"",
//                "time_out":"",
//                "time_remarks_in":"",
//                "time_remarks_out":"",
//                "worked_hour":"",
//                "is_special":false,
//                "shift_index":0,
//                "status":"Absent"
//             }
//          ],
//          "has_multiple_shifts":false,
//          "day_has_leave":false,
//          "day_has_ov":false,
//          "day_has_holiday":false,
//          "day_is_weekend":false,
//          "company_weekends":[
//             "saturday"
//          ],
//          "overall_status":"Absent"
//       }

//    ],
//    "enable_nepali_date":true
// }

// import 'package:flutter/material.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart';

// class DateConverterPage extends StatefulWidget {
//   const DateConverterPage({super.key});

//   @override
//   State<DateConverterPage> createState() => _DateConverterPageState();
// }

// class _DateConverterPageState extends State<DateConverterPage> {
//   NepaliDateTime? _nepaliDate;
//   DateTime? _englishDate;

//   void _selectNepaliDate() async {
//     final pickedDate = await showAdaptiveDatePicker(
//       context: context,
//       initialDate: NepaliDateTime.now(),
//       firstDate: NepaliDateTime(2000),
//       lastDate: NepaliDateTime(2090),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _nepaliDate = pickedDate;
//         _englishDate = pickedDate.toDateTime(); // Converts to English (AD)
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nepaliStr = _nepaliDate != null
//         ? NepaliDateFormat("yyyy-MM-dd").format(_nepaliDate!)
//         : "Not selected";
//     final englishStr = _englishDate != null
//         ? "${_englishDate!.year}-${_englishDate!.month.toString().padLeft(2, '0')}-${_englishDate!.day.toString().padLeft(2, '0')}"
//         : "Not selected";

//     return Scaffold(
//       appBar: AppBar(title: Text('Nepali to English Date')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Selected Nepali Date: $nepaliStr'),
//             Text('Converted English Date: $englishStr'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectNepaliDate,
//               child: Text('Select Nepali Date'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
