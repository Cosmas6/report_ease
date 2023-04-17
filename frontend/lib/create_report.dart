import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'package:http/http.dart' as http;
import 'package:report_ease/list_report.dart';
import 'dart:convert';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _siteLocationController = TextEditingController();
  final _teamLeaderController = TextEditingController();
  final _dateController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _completedTasksController = TextEditingController();
  final _pendingTasksController = TextEditingController();
  final _materialsUsedController = TextEditingController();
  final _issuesChallengesController = TextEditingController();
  final _safetyIncidentsController = TextEditingController();
  final _progressPhotosController = TextEditingController();
  final _nextDayPlanController = TextEditingController();

  Future<void> _createReport() async {
    final report = Report(
      projectName: _projectNameController.text,
      siteLocation: _siteLocationController.text,
      teamLeader: _teamLeaderController.text,
      date: DateTime.parse(_dateController.text),
      workHours: int.parse(_workHoursController.text),
      completedTasks: _completedTasksController.text.split(','),
      pendingTasks: _pendingTasksController.text.split(','),
      materialsUsed: _materialsUsedController.text.split(','),
      issuesChallenges: _issuesChallengesController.text.split(','),
      safetyIncidents: _safetyIncidentsController.text.split(','),
      progressPhotos: _progressPhotosController.text.split(','),
      nextDayPlan: _nextDayPlanController.text,
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _siteLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Site Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the site location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _teamLeaderController,
                  decoration: const InputDecoration(
                    labelText: 'Team Leader',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the team leader';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _workHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Work Hours',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the work hours';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _completedTasksController,
                  decoration: const InputDecoration(
                    labelText: 'Completed Tasks (comma-separated)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the completed tasks';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pendingTasksController,
                  decoration: const InputDecoration(
                    labelText: 'Pending Tasks (comma-separated)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the pending tasks';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _materialsUsedController,
                  decoration: const InputDecoration(
                    labelText: 'Materials Used (comma-separated)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the materials used';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _issuesChallengesController,
                  decoration: const InputDecoration(
                    labelText: 'Issues/Challenges (comma-separated)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the issues/challenges';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _safetyIncidentsController,
                  decoration: const InputDecoration(
                    labelText: 'Safety Incidents (comma-separated)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the safety incidents';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _progressPhotosController,
                  decoration: const InputDecoration(
                    labelText: 'Progress Photos (comma-separated URLs)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the progress photos';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nextDayPlanController,
                  decoration: const InputDecoration(
                    labelText: 'Next Day Plan',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the next day plan';
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
      ),
    );
  }
}
