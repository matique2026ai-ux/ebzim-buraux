import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final notifsAsync = ref.watch(notificationsProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor), onPressed: () => context.pop()),
        title: Text(loc.notifTitle, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildFilter('All'),
                const SizedBox(width: 8),
                _buildFilter('Unread'),
                const SizedBox(width: 8),
                _buildFilter('Updates'),
              ],
            ),
          ),
          Expanded(
            child: notifsAsync.when(
              data: (notifs) {
                final filtered = notifs.where((n) {
                  if (_filter == 'Unread') return !n.isRead;
                  if (_filter == 'Updates') return n.type == 'update';
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(child: Text(loc.noNotifs, style: const TextStyle(color: Colors.grey)));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final n = filtered[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: n.isRead ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: n.isRead ? Colors.grey.shade300 : Colors.white),
                        boxShadow: n.isRead ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: n.isRead ? Colors.grey.shade100 : AppTheme.primaryColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Icon(n.type == 'event' ? Icons.event : (n.type == 'membership' ? Icons.badge : Icons.notifications), color: n.isRead ? Colors.grey : AppTheme.primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(n.title, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 16))),
                                    Text(DateFormat('MMM d').format(n.timestamp), style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(n.description, style: TextStyle(fontSize: 14, color: AppTheme.textDark.withValues(alpha: n.isRead ? 0.6 : 0.8), height: 1.4)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e,s) => Center(child: Text(e.toString())), 
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilter(String title) {
    final isSelected = _filter == title;
    return GestureDetector(
      onTap: () => setState(() => _filter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: isSelected ? Colors.white : Colors.grey.shade600)),
      ),
    );
  }
}
