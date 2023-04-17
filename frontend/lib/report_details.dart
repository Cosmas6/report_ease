import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'package:report_ease/edit_report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportHolder {
  Report report;

  ReportHolder({required this.report});
}

class ReportDetails extends StatefulWidget {
  final ReportHolder reportHolder;

  const ReportDetails({required this.reportHolder, Key? key}) : super(key: key);

  @override
  ReportDetailsState createState() => ReportDetailsState();
}

pw.Document generateReportPdf(Report report) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Report Details'),
            pw.Divider(),
            pw.Text('Project Name: ${report.projectName}'),
            pw.Text('Site Location: ${report.siteLocation}'),
            pw.Text('Team Leader: ${report.teamLeader}'),
            pw.Text('Date: ${report.date}'),
            pw.Text('Work Hours: ${report.workHours}'),
            pw.Text('Completed Tasks: ${report.completedTasks}'),
            pw.Text('Pending Tasks: ${report.pendingTasks}'),
            pw.Text('Materials Used: ${report.materialsUsed}'),
            pw.Text('Issues and Challenges: ${report.issuesChallenges}'),
            pw.Text('Safety Incidents: ${report.safetyIncidents}'),
            pw.Text('Progress Photos: ${report.progressPhotos}'),
            pw.Text('Next Day Plan: ${report.nextDayPlan}'),
          ],
        ); // Column
      },
    ), // Page
  );

  return pdf;
}

class ReportDetailsState extends State<ReportDetails> {
  Future<void> _navigateToEditReport(Report report) async {
    final updatedReport = await Navigator.push<Report>(
      context,
      MaterialPageRoute(
        builder: (context) => EditReport(
          report: report,
          onUpdateSuccess: (updatedReport) {
            Navigator.pop(context, updatedReport); // Pop the EditReport screen
            // Refresh the report_details component or perform any other action you need
          },
        ),
      ),
    );

    if (updatedReport != null) {
      setState(() {
        widget.reportHolder.report = updatedReport;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Field')),
              DataColumn(label: Text('Value')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Project Name')),
                DataCell(Text(widget.reportHolder.report.projectName)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Site Location')),
                DataCell(Text(widget.reportHolder.report.siteLocation)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Team Leader')),
                DataCell(Text(widget.reportHolder.report.teamLeader)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Date')),
                DataCell(
                    Text(widget.reportHolder.report.date.toIso8601String())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Work Hours')),
                DataCell(Text(widget.reportHolder.report.workHours.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Completed Tasks')),
                DataCell(
                    Text(widget.reportHolder.report.completedTasks.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Pending Tasks')),
                DataCell(
                    Text(widget.reportHolder.report.pendingTasks.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Materials Used')),
                DataCell(
                    Text(widget.reportHolder.report.materialsUsed.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Issues and Challenges')),
                DataCell(Text(
                    widget.reportHolder.report.issuesChallenges.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Safety Incidents')),
                DataCell(Text(
                    widget.reportHolder.report.safetyIncidents.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Progress Photos')),
                DataCell(
                    Text(widget.reportHolder.report.progressPhotos.join(', '))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Next Day Plan')),
                DataCell(Text(widget.reportHolder.report.nextDayPlan)),
              ]),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {},
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _navigateToEditReport(widget.reportHolder.report);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
