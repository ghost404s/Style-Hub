import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../orders/order_history_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          ListenableBuilder(
            listenable: state,
            builder: (context, _) => TextButton(
              onPressed:
                  state.unreadCount > 0 ? state.markAllRead : null,
              child: const Text('Mark all read'),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final notifications = state.notifications;
          if (notifications.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'All caught up',
              message:
                  'You have no notifications right now. We’ll let you know '
                  'when something happens.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final notification = notifications[i];
              return _NotificationTile(
                notification: notification,
                onTap: () {
                  state.markRead(notification);
                  if (notification.type == NotificationType.order) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});
  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (notification.type) {
      NotificationType.order => (
          const Color(0xFFE9E5FD),
          AppColors.accent
        ),
      NotificationType.offer => (
          const Color(0xFFFDF3E3),
          const Color(0xFFF5A623)
        ),
      NotificationType.system => (
          const Color(0xFFE6F6EE),
          const Color(0xFF1F9D55)
        ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.read ? AppColors.surface : AppColors.accentLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.read ? AppColors.border : AppColors.accent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(notification.icon,
                  color: foreground, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 14,
                            fontWeight: notification.read
                                ? FontWeight.w600
                                : FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!notification.read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 13,
                        height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    friendlyTime(notification.time),
                    style:
                        TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}