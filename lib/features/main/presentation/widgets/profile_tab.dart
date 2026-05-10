import 'package:flutter/material.dart';

import 'package:unitrade/features/main/presentation/widgets/shared_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.onBack,
    required this.onOpenNotifications,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 14, bottom: 30),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                HeaderIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Your Space',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: onOpenNotifications,
          ),
          SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: 'Privacy & Security',
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.help_outline_rounded,
            label: 'Help Center',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.report_gmailerrorred_outlined,
            label: 'Report a Problem',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFB91C1C)),
            label: const Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFB91C1C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
