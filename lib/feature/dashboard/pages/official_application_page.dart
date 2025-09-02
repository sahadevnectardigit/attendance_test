import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

class OfficialApplicationPage extends StatefulWidget {
  const OfficialApplicationPage({super.key});

  @override
  State<OfficialApplicationPage> createState() =>
      _OfficialApplicationPageState();
}

class _OfficialApplicationPageState extends State<OfficialApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  //application
  int? _officialVisit;

  // String? _officialVisit;
  DateTime? _fromDate;
  DateTime? _toDate;
  NepaliDateTime? _fromDateNepali;
  NepaliDateTime? _toDateNepali;
  String? _approver;
  String? _recommender;
  String? _place;
  String? _remarks;
  double _allowance = 0;
  bool _halfDay = false;

  // Variables to store dates in both formats for API
  String? _fromDateEnglish;
  String? _toDateEnglish;
  String? _fromDateNepaliStr;
  String? _toDateNepaliStr;

  Future<void> _pickDate(bool isFrom) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        if (isFrom) {
          _fromDate = date;
          _fromDateNepali = NepaliDateTime.fromDateTime(date);
          // Store formatted dates for API
          _fromDateEnglish = _formatEnglishDate(date);
          _fromDateNepaliStr = _formatNepaliDate(_fromDateNepali!);
        } else {
          _toDate = date;
          _toDateNepali = NepaliDateTime.fromDateTime(date);
          // Store formatted dates for API
          _toDateEnglish = _formatEnglishDate(date);
          _toDateNepaliStr = _formatNepaliDate(_toDateNepali!);
        }
      });

      // Print for debugging (remove in production)
      print(
        'From Date - English: $_fromDateEnglish, Nepali: $_fromDateNepaliStr',
      );
      print('To Date - English: $_toDateEnglish, Nepali: $_toDateNepaliStr');
    }
  }

  String _formatEnglishDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickNepaliDate(bool isFrom) async {
    final date = await showNepaliDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2080),
      lastDate: NepaliDateTime(2090),
    );

    if (date != null) {
      setState(() {
        if (isFrom) {
          _fromDateNepali = date;
          _fromDate = date.toDateTime();
          // Store formatted dates for API
          _fromDateEnglish = _formatEnglishDate(_fromDate!);
          _fromDateNepaliStr = _formatNepaliDate(date);
        } else {
          _toDateNepali = date;
          _toDate = date.toDateTime();
          // Store formatted dates for API
          _toDateEnglish = _formatEnglishDate(_toDate!);
          _toDateNepaliStr = _formatNepaliDate(date);
        }
      });

      // Print for debugging (remove in production)
      print(
        'From Date - English: $_fromDateEnglish, Nepali: $_fromDateNepaliStr',
      );
      print('To Date - English: $_toDateEnglish, Nepali: $_toDateNepaliStr');
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare data for API with both date formats
      final applicationData = {
        'officialVisit': _officialVisit,
        'fromDateEnglish': _fromDateEnglish,
        'toDateEnglish': _toDateEnglish,
        'fromDateNepali': _fromDateNepaliStr,
        'toDateNepali': _toDateNepaliStr,
        'place': _place,
        'allowance': _allowance,
        'halfDay': _halfDay,
        'remarks': _remarks,
      };

      print('Application Data: $applicationData'); // Debug print

      // TODO: Call API to submit data with both date formats
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Application Submitted')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationProvider>().fetchOfficialVisitData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final officialVisitPro = context.watch<ApplicationProvider>();
    final officiVistData = officialVisitPro.officialVisitModelList;
    return Scaffold(
      appBar: AppBar(title: Text("Official Application")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Official Visit"),
                items: officiVistData
                    ?.map(
                      (e) => DropdownMenuItem(
                        value: e.id, // store ID
                        child: Text(e.name), // display Name
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() => _officialVisit = val);
                },
                validator: (value) =>
                    value == null ? 'Please select official visit type' : null,
              ),

              SizedBox(height: 16),
              Text('From Date:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "English Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(true),
                      controller: TextEditingController(
                        text: _fromDate == null
                            ? ''
                            : _fromDate!.toLocal().toString().split(' ')[0],
                      ),
                      validator: (value) => value?.isEmpty == true
                          ? 'Please select from date'
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Nepali Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickNepaliDate(true),
                      controller: TextEditingController(
                        text: _fromDateNepali == null
                            ? ''
                            : '${_fromDateNepali!.year}-${_fromDateNepali!.month.toString().padLeft(2, '0')}-${_fromDateNepali!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('To Date:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "English Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(false),
                      controller: TextEditingController(
                        text: _toDate == null
                            ? ''
                            : _toDate!.toLocal().toString().split(' ')[0],
                      ),
                      validator: (value) => value?.isEmpty == true
                          ? 'Please select to date'
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Nepali Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickNepaliDate(false),
                      controller: TextEditingController(
                        text: _toDateNepali == null
                            ? ''
                            : '${_toDateNepali!.year}-${_toDateNepali!.month.toString().padLeft(2, '0')}-${_toDateNepali!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Place of Visit"),
                onSaved: (val) => _place = val,
                validator: (value) => value?.isEmpty == true
                    ? 'Please enter place of visit'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Allowance Claimed"),
                keyboardType: TextInputType.number,
                onSaved: (val) => _allowance = double.tryParse(val ?? "0") ?? 0,
              ),
              SwitchListTile(
                value: _halfDay,
                onChanged: (val) => setState(() => _halfDay = val),
                title: Text("Half Day?"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Remarks"),
                maxLines: 3,
                onSaved: (val) => _remarks = val,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: Text("Save"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _saveForm,
                      child: Text("Save & Continue"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
