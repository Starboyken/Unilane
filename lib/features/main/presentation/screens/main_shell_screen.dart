import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/add_listing_screen.dart';
import 'package:unilane/features/main/presentation/screens/notifications_screen.dart';
import 'package:unilane/features/main/presentation/widgets/home_tab.dart';
import 'package:unilane/features/main/presentation/widgets/marketplace_tab.dart';
import 'package:unilane/features/main/presentation/widgets/messages_tab.dart';
import 'package:unilane/features/main/presentation/widgets/profile_tab.dart';
import 'package:unilane/features/main/presentation/widgets/services_tab.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final currentIndex = provider.selectedTabIndex;
    final unreadNotificationCount = provider.unreadNotificationCount;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeTab(onOpenNotifications: () => _openNotifications(context)),
          MarketplaceTab(onBack: () => provider.setSelectedTab(0)),
          const ServicesTab(),
          const MessagesTab(),
          ProfileTab(
            onBack: () => provider.setSelectedTab(0),
            onOpenNotifications: () => _openNotifications(context),
            unreadNotificationCount: unreadNotificationCount,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, currentIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: provider.setSelectedTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3B5BDB),
          unselectedItemColor: const Color(0xFF6B7280),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, int currentIndex) {
    if (currentIndex == 1) {
      return FloatingActionButton(
        onPressed: () async {
          final addedListing = await Navigator.of(context).push<ListingItem>(
            MaterialPageRoute<ListingItem>(
              builder: (context) => const AddListingScreen(),
            ),
          );

          if (addedListing == null || !context.mounted) {
            return;
          }

          context.read<CampusMartProvider>().openMarketplace(
            category: addedListing.category,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${addedListing.title} posted on UniLane'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 30),
      );
    }

    return null;
  }
}
