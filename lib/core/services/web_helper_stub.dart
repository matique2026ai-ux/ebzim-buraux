import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

void triggerWebDownload(String content, String filename) {
  // No-op on non-web platforms
}

void triggerWebDownloadBytes(Uint8List bytes, String filename) {
  // No-op on non-web platforms
}

class WebHelper {
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
