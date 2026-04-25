import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'app_locale';

  LocaleNotifier() : super(const Locale('ar', 'DZ')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final saved = await _storage.read(key: _key);
      if (saved != null) {
        if (saved == 'ar') {
          state = const Locale('ar', 'DZ');
        } else {
          state = Locale(saved);
        }
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale locale) async {
    // Force DZ region for Arabic to get Latin numbers
    if (locale.languageCode == 'ar') {
      state = const Locale('ar', 'DZ');
    } else {
      state = locale;
    }
    await _storage.write(key: _key, value: state.languageCode);
  }
}
