import 'dart:convert';
import 'dart:io';

void main() {
  final arFile = File('lib/core/localization/l10n/app_ar.arb');
  final frFile = File('lib/core/localization/l10n/app_fr.arb');
  
  final arData = json.decode(arFile.readAsStringSync()) as Map<String, dynamic>;
  final frData = json.decode(frFile.readAsStringSync()) as Map<String, dynamic>;
  
  final arKeys = arData.keys.toSet();
  final frKeys = frData.keys.toSet();
  
  final missing = arKeys.difference(frKeys);
  print('Keys in Arabic but not in French:');
  missing.forEach(print);
  
  final missingAr = frKeys.difference(arKeys);
  print('Keys in French but not in Arabic:');
  missingAr.forEach(print);
}
