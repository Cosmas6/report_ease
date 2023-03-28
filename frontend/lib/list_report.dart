import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'package:report_ease/edit_report.dart';
import 'package:report_ease/report_details.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer' as developer;

import 'dart:convert';

class ListReports extends StatefulWidget {
  const ListReports({Key? key}) : super(key: key);

  @override
  State<ListReports> createState() => _ListReportsState();
}

class _ListReportsState extends State<ListReports> {
  late List<Report> _reports = [];

  Future<List<Report>> _fetchReports() async {
    final response = await http.get(
      Uri.parse('https://nodejs.tmwdp.co.ke/FlutterReportRoute/list-reports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final reports = <Report>[];

      for (var item in json) {
        final report = Report.fromJson(item);
        report.id = item['_id'];
        reports.add(report);
      }

      return reports;
    } else {
      throw Exception('Failed to load reports');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReports().then((reports) {
      setState(() {
        _reports = reports;
      });
    });
  }

  Future<void> _editReport(Report report) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReport(
          report: report,
          onUpdateSuccess: () {
            Navigator.pop(context, true); // Pop the EditReport screen
            // Refresh the report_details component or perform any other action you need
          },
        ),
      ),
    );
    if (result == true) {
      // Report was updated successfully, so refresh the list
      final reports = await _fetchReports();
      setState(() {
        _reports = reports;
      });
    }
  }

  Future<void> _deleteReport(int index, Report report) async {
    // Show a dialog to confirm deletion

    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // If the user confirmed the deletion, send a DELETE request to the server
    if (confirm == true) {
      final response = await http.delete(
        Uri.parse('https://nodejs.tmwdp.co.ke/FlutterReportRoute/delete-report/${report.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (!mounted) return;

      // If the delete request was successful, remove the record from the list of reports
      if (response.statusCode == 200) {
        setState(() {
          _reports.removeAt(index);
        });
      } else {
        // If the delete request failed, show an error message

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete report: ${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Reports'),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (BuildContext context, int index) {
          final report = _reports[index];
          return Card(
            child: ListTile(
              title: Text(report.name),
              subtitle: Text(report.department),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDetails(reportHolder: ReportHolder(report: report)),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editReport(report.copyWith(id: report.id));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteReport(index, report),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}