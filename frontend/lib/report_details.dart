import 'package:flutter/material.dart';
import 'package:report_ease/report.dart';
import 'package:report_ease/edit_report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

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
            pw.Text('Name: ${report.name}'),
            pw.Text('Department: ${report.department}'),
            pw.Text('Activity: ${report.activity}'),
            // Add any additional fields as needed
          ],
        ); // Column
      },
    ), // Page
  );

  return pdf;
}

// Future<bool> _requestStoragePermission() async {
//   PermissionStatus status = await Permission.storage.status;
//   if (status.isDenied) {
//     status = await Permission.storage.request();
//   }
//   return status.isGranted;
// }

// Future<void> _savePdfToDevice(pw.Document pdf) async {
//   bool permissionGranted = await _requestStoragePermission();
//   if (!permissionGranted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Storage permission is not granted')),
//     );
//     return;
//   }

//   try {
//     final directory = await getExternalStorageDirectory();
//     final pdfFile = File('${directory.path}/report.pdf');
//     await pdfFile.writeAsBytes(await pdf.save());

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('PDF saved to ${pdfFile.path}')),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error saving PDF: $e')),
//     );
//   }
// }

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
                const DataCell(Text('Name')),
                DataCell(Text(widget.reportHolder.report.name)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Department')),
                DataCell(Text(widget.reportHolder.report.department)),
              ]),
              DataRow(cells: [
                const DataCell(Text('Activity')),
                DataCell(Text(widget.reportHolder.report.activity)),
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
                  onPressed: () async {
                    // final pdf = generateReportPdf(widget.reportHolder.report);
                    // _savePdfToDevice(pdf);
                    // await Printing.sharePdf(
                    //     bytes: await pdf.save(), filename: 'report.pdf');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _navigateToEditReport(widget.reportHolder.report);
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.delete),
                //   onPressed: () {
                //     // Delete the report
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
