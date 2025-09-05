import 'dart:developer';

import 'package:attendance/feature/dashboard/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali_picker;
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

class LateInLateOutPage extends StatefulWidget {
  const LateInLateOutPage({super.key});

  @override
  State<LateInLateOutPage> createState() => _LateInLateOutPageState();
}

class _LateInLateOutPageState extends State<LateInLateOutPage> {
  final remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? lateInLateOut;
  final lateOptions = ["Late In", "Late Out"];

  DateTime? englishDate;
  NepaliDateTime? nepaliDate;
  int? approver;
  int? recommender;
  String? remarks;

  // Variables to store dates in both formats for API
  String? _dateEnglish;
  String? _dateNepaliStr;

  // Method to update English date from Nepali date
  void _updateEnglishDateFromNepali(NepaliDateTime pickedNepaliDate) {
    setState(() {
      nepaliDate = pickedNepaliDate;
      englishDate = pickedNepaliDate.toDateTime();
      // Store formatted dates for API
      _dateEnglish = _formatEnglishDate(englishDate!);
      _dateNepaliStr = _formatNepaliDate(nepaliDate!);
    });
  }

  // Method to update Nepali date from English date
  void _updateNepaliDateFromEnglish(DateTime pickedEnglishDate) {
    setState(() {
      englishDate = pickedEnglishDate;
      nepaliDate = NepaliDateTime.fromDateTime(pickedEnglishDate);
      // Store formatted dates for API
      _dateEnglish = _formatEnglishDate(englishDate!);
      _dateNepaliStr = _formatNepaliDate(nepaliDate!);
    });
  }

  String _formatEnglishDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // English Date Picker
  Future<void> _pickEnglishDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: englishDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _updateNepaliDateFromEnglish(picked);
    }
  }

  // Nepali Date Picker
  Future<void> _pickNepaliDate() async {
    final picked = await nepali_picker.showNepaliDatePicker(
      context: context,
      initialDate: nepaliDate ?? NepaliDateTime.now(),
      firstDate: NepaliDateTime(2080),
      lastDate: NepaliDateTime.now(),
    );
    if (picked != null) {
      _updateEnglishDateFromNepali(picked);
    }
  }

  void _clearForm() {
    setState(() {
      lateInLateOut = null;
      englishDate = null;
      nepaliDate = null;
      approver = null;
      recommender = null;
      remarkController.text = '';
    });
  }

  void _handleFrom() async {
    if (_formKey.currentState!.validate()) {
      final applicationPro = Provider.of<ApplicationProvider>(
        context,
        listen: false,
      );

      if (englishDate == null || nepaliDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare data for API with both date formats
      final applicationData = {
        "late_in_out": lateInLateOut,
        "date_en": _dateEnglish,
        "date_np": _dateNepaliStr,
        "approved_by": approver,
        "recommended_by": recommender,
        "remarks": remarkController.text.trim(),
      };
      final isSuccess = await applicationPro.postLateInEarlyOut(
        context: context,
        applicationData: applicationData,
      );

      if (isSuccess) {
        _clearForm();
      }
      log('Application Data: $applicationData');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationProvider>().fetchApproveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Late In / Late Out Application"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<ApplicationProvider>(
            builder: (context, applicationPro, child) {
              final approveData = applicationPro.fetchApproveState.data;
              return Stack(
                children: [
                  ListView(
                    children: [
                      // Late In/Late Out Dropdown
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Late In / Late Out",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            // initialValue: lateInLateOut,
                            value: lateInLateOut,
                            items: lateOptions
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => lateInLateOut = val),
                            validator: (value) =>
                                value == null ? 'Please select type' : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Date Section Header
                      Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // English Date Picker
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "English Date (AD)",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickEnglishDate,
                          controller: TextEditingController(
                            text: englishDate != null
                                ? "${englishDate!.year}-${englishDate!.month.toString().padLeft(2, '0')}-${englishDate!.day.toString().padLeft(2, '0')}"
                                : '',
                          ),
                          validator: (value) => value?.isEmpty == true
                              ? 'Please select date'
                              : null,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Nepali Date Picker
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Nepali Date (BS)",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _pickNepaliDate,
                          controller: TextEditingController(
                            text: nepaliDate != null
                                ? "${nepaliDate!.year}-${nepaliDate!.month.toString().padLeft(2, '0')}-${nepaliDate!.day.toString().padLeft(2, '0')}"
                                : '',
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Date Conversion Info
                      if (englishDate != null && nepaliDate != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${englishDate!.day}/${englishDate!.month}/${englishDate!.year} (AD) = ${nepaliDate!.day}/${nepaliDate!.month}/${nepaliDate!.year} (BS)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Approver Dropdown
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: "Approved By",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            // initialValue: approver,
                            value:approver,
                            items: approveData?.approvedBy
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.firstName),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => setState(() => approver = val),
                            validator: (value) =>
                                value == null ? 'Please select approver' : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Recommender Dropdown
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: "Recommended By",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            // initialValue: recommender,
                            value:recommender,
                            items: approveData?.recommendedBy
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.firstName),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => recommender = val),
                            validator: (value) => value == null
                                ? 'Please select recommender'
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Remarks
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: remarkController,
                          decoration: const InputDecoration(
                            labelText: "Remarks",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(color: Colors.blue[700]!),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleFrom(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.blue[700],
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
