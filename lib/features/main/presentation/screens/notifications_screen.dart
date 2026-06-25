import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/chat_detail_screen.dart';
import 'package:unilane/features/main/presentation/screens/lodges_screen.dart';
import 'package:unilane/features/main/presentation/screens/product_detail_screen.dart';
import 'package:unilane/features/main/presentation/screens/roommates_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final notificationItems = provider.notificationItems;
    final unreadCount = provider.unreadNotificationCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 14, 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Text(
                    'UniLane Alerts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: unreadCount == 0
                        ? null
                        : provider.markAllNotificationsRead,
                    child: Text(
                      unreadCount == 0 ? 'All caught up' : 'Mark all as read',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            if (notificationItems.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No notifications yet.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: notificationItems.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final item = notificationItems[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openNotification(context, item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEFF4FF),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item.icon,
                                  size: 18,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: item.isUnread
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: const Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.time,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item.isUnread)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 7),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2563EB),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openNotification(BuildContext context, NotificationItem item) {
    final provider = context.read<CampusMartProvider>();
    provider.markNotificationRead(item.id);

    switch (item.destinationType) {
      case NotificationDestinationType.conversation:
        final conversationId = item.destinationId;
        if (conversationId == null || conversationId.isEmpty) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                ChatDetailScreen(conversationId: conversationId),
          ),
        );
        return;
      case NotificationDestinationType.listing:
        final listingId = item.destinationId;
        if (listingId == null || listingId.isEmpty) {
          return;
        }

        final listing = provider.getListingBySlug(listingId);
        if (listing == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('That listing is no longer available.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProductDetailScreen(listing: listing),
          ),
        );
        return;
      case NotificationDestinationType.marketplaceCategory:
        final category = item.marketplaceCategory ?? 'All';
        if (category == 'Roommates') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const RoommatesScreen(),
            ),
          );
          return;
        }

        if (category == 'Lodges') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => const LodgesScreen()),
          );
          return;
        }

        provider.openMarketplace(category: category);
        Navigator.of(context).pop();
        return;
      case NotificationDestinationType.roommates:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const RoommatesScreen(),
          ),
        );
        return;
      case NotificationDestinationType.lodges:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const LodgesScreen()),
        );
        return;
    }
  }
}
