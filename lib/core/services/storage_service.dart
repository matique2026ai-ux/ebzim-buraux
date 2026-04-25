import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  // Use WebOptions to ensure compatibility with browser storage mechanisms.
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    webOptions: WebOptions(dbName: 'ebzim_auth', publicKey: 'ebzim_key'),
  );

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static const String _firstLaunchKey = 'is_first_launch_v1';
  static const String _lastIdentityKey = 'last_identity';

  Future<bool> isFirstLaunch() async {
    final val = await _storage.read(key: _firstLaunchKey);
    return val == null || val == 'true';
  }

  Future<void> setFirstLaunchCompleted() async {
    await _storage.write(key: _firstLaunchKey, value: 'false');
  }

  Future<void> saveLastIdentity(String identity) async {
    await _storage.write(key: _lastIdentityKey, value: identity);
  }

  Future<String?> getLastIdentity() async {
    return await _storage.read(key: _lastIdentityKey);
  }
}

final storageServiceProvider = Provider((ref) => StorageService());
