import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotification {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'update', 'event', 'membership'

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}

class NotificationService {
  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      AppNotification(
        id: '1',
        title: 'New Archive Access',
        description:
            'The 19th-century collection of Ebzim artifacts is now digitally available for premium members.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: 'membership',
      ),
      AppNotification(
        id: '2',
        title: 'Calligraphy Masterclass',
        description:
            'Reminder: The upcoming masterclass begins in less than 48 hours.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: 'event',
      ),
      AppNotification(
        id: '3',
        title: 'Annual General Meeting',
        description:
            'The association general meeting agenda has been finalized and published.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        type: 'update',
      ),
    ];
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String description,
    required String type,
  }) async {
    // In a real app, this would be a POST to /notifications
    // For this institutional version, we simulate the success
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService());

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) {
  return ref.read(notificationServiceProvider).getNotifications();
});
