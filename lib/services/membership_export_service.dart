import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:ebzim_app/core/services/membership_service.dart';

class MembershipExportService {
  /// Triggers a browser download for the given bytes.
  static void triggerWebDownloadBytes(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  /// Exports a list of membership requests to an Excel file.
  static Future<bool> exportToExcel(List<MembershipRequest> requests) async {
    try {
      if (requests.isEmpty) return false;

      final excel = Excel.createExcel();
      // Remove default sheet
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }

      final sheet = excel['Memberships'];

      // Header row
      final headers = [
        'Full Name',
        'Email',
        'Phone',
        'Status',
        'Submission Date',
      ];

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(headers[i]);
      }

      // Data rows
      for (int i = 0; i < requests.length; i++) {
        final r = requests[i];
        final rowIndex = i + 1;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(r.fullName);
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(r.data['email'] ?? 'N/A');
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(r.data['phone'] ?? 'N/A');
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(r.status);
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = TextCellValue(DateFormat('yyyy-MM-dd').format(r.submissionDate));
      }

      final bytes = excel.encode();
      if (bytes != null) {
        triggerWebDownloadBytes(
          Uint8List.fromList(bytes),
          'ebzim_memberships_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx',
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
