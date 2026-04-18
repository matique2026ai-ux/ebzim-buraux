import 'dart:convert';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
  html.Url.revokeObjectUrl(url);
}
