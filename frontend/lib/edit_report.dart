import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
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

  // Add controllers for the remaining fields
  // ...

  @override
  void initState() {
    super.initState();
    _projectNameController.text = widget.report.projectName;
    _siteLocationController.text = widget.report.siteLocation;
    _teamLeaderController.text = widget.report.teamLeader;
    _dateController.text = widget.report.date.toIso8601String();
    _workHoursController.text = widget.report.workHours.toString();
    _completedTasksController.text = widget.report.completedTasks.join(', ');
    _pendingTasksController.text = widget.report.pendingTasks.join(', ');
    _materialsUsedController.text = widget.report.materialsUsed.join(', ');
    _issuesChallengesController.text =
        widget.report.issuesChallenges.join(', ');
    _safetyIncidentsController.text = widget.report.safetyIncidents.join(', ');
    _progressPhotosController.text = widget.report.progressPhotos.join(', ');
    _nextDayPlanController.text = widget.report.nextDayPlan;
    // Initialize the remaining fields
    // ...
  }

  Future<void> _updateReport() async {
    final report = Report(
      id: widget.report.id,
      projectName: _projectNameController.text,
      siteLocation: _siteLocationController.text,
      teamLeader: _teamLeaderController.text,
      date: DateTime.parse(_dateController.text),
      workHours: int.parse(_workHoursController.text),
      completedTasks: _completedTasksController.text.split(', '),
      pendingTasks: _pendingTasksController.text.split(', '),
      materialsUsed: _materialsUsedController.text.split(', '),
      issuesChallenges: _issuesChallengesController.text.split(', '),
      safetyIncidents: _safetyIncidentsController.text.split(', '),
      progressPhotos: _progressPhotosController.text.split(', '),
      nextDayPlan: _nextDayPlanController.text,
      // Add the remaining fields
      // ...
    );
    final response = await http.put(
      Uri.parse(
          'https://nodejs.tmwdp.co.ke/FlutterReportRoute/update-report/${report.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(report.toJson()),
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
                      return 'Please enter a project name';
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
                      return 'Please enter a site location';
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
                      return 'Please enter a team leader';
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
                      return 'Please enter a date';
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
                      return 'Please enter work hours';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _completedTasksController,
                  decoration: const InputDecoration(
                    labelText: 'Completed Tasks',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter completed tasks';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pendingTasksController,
                  decoration: const InputDecoration(
                    labelText: 'Pending Tasks',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pending tasks';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _materialsUsedController,
                  decoration: const InputDecoration(
                    labelText: 'Materials Used',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter materials used';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _issuesChallengesController,
                  decoration: const InputDecoration(
                    labelText: 'Issues/Challenges',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter issues/challenges';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _safetyIncidentsController,
                  decoration: const InputDecoration(
                    labelText: 'Safety Incidents',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter safety incidents';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _progressPhotosController,
                  decoration: const InputDecoration(
                    labelText: 'Progress Photos',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter progress photos';
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
                      return 'Please enter next day plan';
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
      ),
    );
  }
}
