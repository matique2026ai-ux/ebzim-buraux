import 'dart:convert';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:url_launcher/url_launcher.dart';

void triggerWebDownload(String content, String filename) {
  // Add UTF-8 BOM to ensure Excel opens Arabic characters correctly
  final bytes = utf8.encode(content);
  final bom = [0xEF, 0xBB, 0xBF];
  final fullContent = Uint8List.fromList([...bom, ...bytes]);

  final blob = html.Blob([fullContent], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  // Minimal delay before revocation to ensure the browser handles the click
  Future.delayed(const Duration(milliseconds: 1000), () {
    html.Url.revokeObjectUrl(url);
  });
}

void triggerWebDownloadBytes(Uint8List bytes, String filename) {
  final blob = html.Blob([
    bytes,
  ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  // Minimal delay before revocation to ensure the browser handles the click
  Future.delayed(const Duration(milliseconds: 1000), () {
    html.Url.revokeObjectUrl(url);
  });
}

class WebHelper {
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
