import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'package:http/http.dart' as http;
import 'package:report_ease/list_report.dart';
import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _activityController = TextEditingController();

  Future<void> _createReport() async {
    final report = Report(
      name: _nameController.text,
      department: _departmentController.text,
      activity: _activityController.text,
    );
    final response = await http.post(
      Uri.parse('https://nodejs.tmwdp.co.ke/FlutterReportRoute/create-report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(report.toJson()),
    );
    if (response.statusCode == 200) {
      // Report was created successfully
      // Navigate back to the previous screen
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ListReports()));
    } else {
      // Failed to create report
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create report'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
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
                    await _createReport();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
