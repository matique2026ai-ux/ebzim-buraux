import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class RealtimeNotification {
  final String title;
  final String message;
  final DateTime timestamp;

  RealtimeNotification({
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

final realtimeNotificationProvider = StreamProvider<RealtimeNotification>((ref) {
  final supabase = ref.watch(supabaseServiceProvider).client;
  final controller = StreamController<RealtimeNotification>();

  final channel = supabase.channel('announcements');
  
  channel.onBroadcast(
    event: 'new_announcement',
    callback: (payload) {
      final notification = RealtimeNotification(
        title: payload['title'] ?? 'تنبيه جديد',
        message: payload['message'] ?? '',
        timestamp: DateTime.now(),
      );
      controller.add(notification);
    },
  ).subscribe();

  ref.onDispose(() {
    supabase.removeChannel(channel);
    controller.close();
  });

  return controller.stream;
});

class AnnouncementNotifier extends StateNotifier<bool> {
  final SupabaseClient _client;
  AnnouncementNotifier(this._client) : super(false);

  Future<void> sendAnnouncement(String title, String message) async {
    state = true;
    try {
      final channel = _client.channel('announcements');
      // In newer Supabase SDK, sendBroadcast is actually send() with map
      await (channel as dynamic).send(
        type: 'broadcast',
        event: 'new_announcement',
        payload: {
          'title': title,
          'message': message,
        },
      );
    } catch (e) {
      print('Error sending announcement: $e');
    } finally {
      state = false;
    }
  }
}

final announcementProvider = StateNotifierProvider<AnnouncementNotifier, bool>((ref) {
  return AnnouncementNotifier(ref.watch(supabaseServiceProvider).client);
});
