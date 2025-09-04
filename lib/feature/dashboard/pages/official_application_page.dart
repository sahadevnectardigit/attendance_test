import 'dart:developer';

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

  // Controllers
  final _placeController = TextEditingController();
  final _remarkController = TextEditingController();
  final _allowanceController = TextEditingController();

  // Form values
  int? _officialVisit;
  int? _approverId;
  int? _recommenderId;
  DateTime? _fromDate;
  DateTime? _toDate;
  NepaliDateTime? _fromDateNepali;
  NepaliDateTime? _toDateNepali;
  bool _halfDay = false;

  // API date formats
  String? _fromDateEnglish;
  String? _toDateEnglish;
  String? _fromDateNepaliStr;
  String? _toDateNepaliStr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApplicationProvider>()
        ..fetchOfficialVisitData()
        ..fetchApproveData();
    });
  }

  @override
  void dispose() {
    _placeController.dispose();
    _remarkController.dispose();
    _allowanceController.dispose();
    super.dispose();
  }

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
          _fromDateEnglish = _formatEnglishDate(date);
          _fromDateNepaliStr = _formatNepaliDate(_fromDateNepali!);
        } else {
          _toDate = date;
          _toDateNepali = NepaliDateTime.fromDateTime(date);
          _toDateEnglish = _formatEnglishDate(date);
          _toDateNepaliStr = _formatNepaliDate(_toDateNepali!);
        }
      });
    }
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
          _fromDateEnglish = _formatEnglishDate(_fromDate!);
          _fromDateNepaliStr = _formatNepaliDate(date);
        } else {
          _toDateNepali = date;
          _toDate = date.toDateTime();
          _toDateEnglish = _formatEnglishDate(_toDate!);
          _toDateNepaliStr = _formatNepaliDate(date);
        }
      });
    }
  }

  String _formatEnglishDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatNepaliDate(NepaliDateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _clearForm() {
    setState(() {
      // _formKey.currentState?.reset();
      _officialVisit = null;
      _approverId = null;
      _recommenderId = null;
      _fromDate = null;
      _toDate = null;
      _fromDateNepali = null;
      _toDateNepali = null;
      _halfDay = false;
      _placeController.clear();
      _remarkController.clear();
      _allowanceController.clear();
      _fromDateEnglish = null;
      _toDateEnglish = null;
      _fromDateNepaliStr = null;
      _toDateNepaliStr = null;
    });
  }

  Future<void> _handleForm() async {
    if (!_formKey.currentState!.validate()) return;

    final applicationPro = Provider.of<ApplicationProvider>(
      context,
      listen: false,
    );

    final applicationData = {
      "name_id": _officialVisit,
      "from_date_en": _fromDateEnglish,
      "to_date_en": _toDateEnglish,
      "from_date_np": _fromDateNepaliStr,
      "to_date_np": _toDateNepaliStr,
      "approved_by": _approverId,
      "recommended_by": _recommenderId,
      "half_day": _halfDay,
      "remarks": _remarkController.text.trim(),
      "place": _placeController.text.trim(),
      "allowance_claimed": double.tryParse(_allowanceController.text) ?? 0,
    };
    log("Applicaion data: $applicationData");
    final isSuccess = await applicationPro.postOfficialVisit(
      context: context,
      applicationData: applicationData,
    );

    if (isSuccess) {
      _clearForm();
      // Navigator.pop(context);
      // context.showSnackBarMessage(
      //   message: 'Application Submitted successfully',
      //   backgroundColor: Colors.green,
      // );
    }
    // else {
    //   context.showSnackBarMessage(
    //     message: 'Application failed to post',
    //     backgroundColor: Colors.red,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Official Application"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<ApplicationProvider>(
            builder: (context, applicationPro, child) {
              final officiVistData = applicationPro.officialVisitModelList;
              final approveData = applicationPro.approveRecommendModel;
              return ListView(
                children: [
                  // Official Visit Dropdown
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButtonFormField<int>(
                        initialValue: _officialVisit,
                        decoration: InputDecoration(
                          labelText: "Official Visit",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        items: officiVistData
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => _officialVisit = val);
                        },
                        validator: (value) => value == null
                            ? 'Please select official visit type'
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Approver and Recommender in a row
                  Row(
                    children: [
                      // Approver Dropdown
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DropdownButtonFormField<int>(
                              initialValue: _approverId,
                              decoration: InputDecoration(
                                labelText: "Approve By",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: approveData?.approvedBy
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.firstName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _approverId = val);
                              },
                              validator: (value) => value == null
                                  ? 'Please select approver'
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Recommender Dropdown
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DropdownButtonFormField<int>(
                              initialValue: _recommenderId,
                              decoration: InputDecoration(
                                labelText: "Recommend By",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: approveData?.recommendedBy
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.firstName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _recommenderId = val);
                              },
                              validator: (value) => value == null
                                  ? 'Please select recommender'
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // From Date Section
                  Text(
                    'From Date:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "English Date",
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onTap: () => _pickDate(true),
                            controller: TextEditingController(
                              text: _fromDate == null
                                  ? ''
                                  : _fromDate!.toLocal().toString().split(
                                      ' ',
                                    )[0],
                            ),
                            validator: (value) => value?.isEmpty == true
                                ? 'Please select from date'
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Nepali Date",
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onTap: () => _pickNepaliDate(true),
                            controller: TextEditingController(
                              text: _fromDateNepali == null
                                  ? ''
                                  : '${_fromDateNepali!.year}-${_fromDateNepali!.month.toString().padLeft(2, '0')}-${_fromDateNepali!.day.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // To Date Section
                  Text(
                    'To Date:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "English Date",
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
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
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Nepali Date",
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onTap: () => _pickNepaliDate(false),
                            controller: TextEditingController(
                              text: _toDateNepali == null
                                  ? ''
                                  : '${_toDateNepali!.year}-${_toDateNepali!.month.toString().padLeft(2, '0')}-${_toDateNepali!.day.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Place of Visit
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _placeController,
                      decoration: InputDecoration(
                        labelText: "Place of Visit",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) => value?.isEmpty == true
                          ? 'Please enter place of visit'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Allowance Claimed
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _allowanceController,
                      decoration: InputDecoration(
                        labelText: "Allowance Claimed",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Half Day Switch
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SwitchListTile(
                      value: _halfDay,
                      onChanged: (val) => setState(() => _halfDay = val),
                      title: const Text("Half Day?"),
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
                      controller: _remarkController,
                      decoration: InputDecoration(
                        labelText: "Remarks",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      maxLines: 3,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              // applicationPro.isLoadingPostOfficial
                              //     ? null
                              //     :
                              () => _handleForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Submit"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: Colors.blue.shade700),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                        ),
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
