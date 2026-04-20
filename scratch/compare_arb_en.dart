import 'dart:convert';
import 'dart:io';

void main() {
  final arFile = File('lib/core/localization/l10n/app_ar.arb');
  final enFile = File('lib/core/localization/l10n/app_en.arb');
  
  final arData = json.decode(arFile.readAsStringSync()) as Map<String, dynamic>;
  final enData = json.decode(enFile.readAsStringSync()) as Map<String, dynamic>;
  
  final arKeys = arData.keys.toSet();
  final enKeys = enData.keys.toSet();
  
  final missing = arKeys.difference(enKeys);
  print('Keys in Arabic but not in English:');
  missing.forEach(print);
}
