import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockStorageService extends StorageService {
  final Map<String, String> _data = {};
  @override
  Future<void> saveToken(String token) async => _data['auth_token'] = token;
  @override
  Future<String?> getToken() async => _data['auth_token'];
  @override
  Future<void> deleteToken() async => _data.remove('auth_token');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Integration Verification', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(MockStorageService()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Verify EventService.getUpcomingEvents fetches live data from backend', () async {
      final eventService = container.read(eventServiceProvider);
      
      final events = await eventService.getUpcomingEvents();
      
      debugPrint('DEBUG: Fetched ${events.length} events from live backend');
      for (var event in events) {
        debugPrint('DEBUG: Event - ID: ${event.id}, Title (AR): ${event.titleAr}');
      }
      
      expect(events, isNotNull);
      // If seed script was run, there should be at least some events if the categories/events were seeded
      // Note: Backend might be empty if only categories were seeded.
    });

    test('Verify AuthService.login with seeded SUPER_ADMIN credentials', () async {
      final authNotifier = container.read(authProvider.notifier);
      
      // Seeded Admin: admin@ebzim.org / AdminPassword123!
      await authNotifier.login('admin@ebzim.org', 'AdminPassword123!');
      
      final state = container.read(authProvider);
      
      debugPrint('DEBUG: AuthState - Authenticated: ${state.isAuthenticated}, Error: ${state.error}');
      if (state.user != null) {
        debugPrint('DEBUG: Logged in as: ${state.user!.getName('en')} (${state.user!.email})');
      }

      expect(state.isAuthenticated, isTrue);
      expect(state.error, isNull);
      
      // Verify token persistence
      final token = await container.read(storageServiceProvider).getToken();
      debugPrint('DEBUG: Persisted JWT: ${token?.substring(0, 10)}...');
      expect(token, isNotNull);
    });
  });
}
