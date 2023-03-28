import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditReport extends StatefulWidget {
  final Report report;
  final Function onUpdateSuccess;

  const EditReport(
      {required this.report, required this.onUpdateSuccess, Key? key})
      : super(key: key);

  @override
  State<EditReport> createState() => _EditReportState();
}

class _EditReportState extends State<EditReport> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _activityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.report.name;
    _departmentController.text = widget.report.department;
    _activityController.text = widget.report.activity;
  }

  Future<void> _updateReport() async {
    final report = Report(
      id: widget.report.id,
      name: _nameController.text,
      department: _departmentController.text,
      activity: _activityController.text,
    );
    final response = await http.put(
      Uri.parse(
          'https://nodejs.tmwdp.co.ke/FlutterReportRoute/update-report/${report.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(report.toJson()),
    );
    developer.log(
      'Report ID',
      name: 'reportease.app.edit_report',
      error: response.statusCode,
    );
    if (response.statusCode == 200) {
      // Report was updated successfully
      // Navigate back to the previous screen
      if (!mounted) return;

      widget.onUpdateSuccess(report);
    } else {
      // Failed to update report
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update report'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your department';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your activity';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _updateReport();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
