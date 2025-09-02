import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class DateConverterPage extends StatefulWidget {
  const DateConverterPage({super.key});

  @override
  State<DateConverterPage> createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  NepaliDateTime? _nepaliDate;
  DateTime? _englishDate;

  void _selectNepaliDate() async {
    final pickedDate = await showAdaptiveDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
    );

    if (pickedDate != null) {
      setState(() {
        _nepaliDate = pickedDate;
        _englishDate = pickedDate.toDateTime(); // Converts to English (AD)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nepaliStr = _nepaliDate != null
        ? NepaliDateFormat("yyyy-MM-dd").format(_nepaliDate!)
        : "Not selected";
    final englishStr = _englishDate != null
        ? "${_englishDate!.year}-${_englishDate!.month.toString().padLeft(2, '0')}-${_englishDate!.day.toString().padLeft(2, '0')}"
        : "Not selected";

    return Scaffold(
      appBar: AppBar(title: Text('Nepali to English Date')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Nepali Date: $nepaliStr'),
            Text('Converted English Date: $englishStr'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectNepaliDate,
              child: Text('Select Nepali Date'),
            ),
          ],
        ),
      ),
    );
  }
}
