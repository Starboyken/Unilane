import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/auth/presentation/providers/auth_provider.dart';
import 'package:unilane/features/auth/presentation/screens/login_screen.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/edit_profile_screen.dart';
import 'package:unilane/features/main/presentation/screens/settings_detail_screen.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.onBack,
    required this.onOpenNotifications,
    required this.unreadNotificationCount,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenNotifications;
  final int unreadNotificationCount;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final profile = provider.currentUserProfile;
    final isSignedIn = provider.currentUserId != 'guest';

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
                const Expanded(
                  child: Text(
                    'Your Space',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                NotificationButton(
                  key: const Key('profileNotificationButton'),
                  onTap: onOpenNotifications,
                  unreadCount: unreadNotificationCount,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          if (profile != null)
            _ProfileSummaryCard(
              profile: profile,
              onEditProfile: () => _openEditProfile(context, profile),
            )
          else
            _GuestProfileCard(onSignIn: () => _openLogin(context)),
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
            onTap: profile == null
                ? () => _openLogin(context)
                : () => _openEditProfile(context, profile),
          ),
          SettingsTile(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            onTap: onOpenNotifications,
          ),
          SettingsTile(
            icon: Icons.lock_outline_rounded,
            label: 'Privacy & Security',
            onTap: () => _openSettings(
              context,
              title: 'Privacy & Security',
              description:
                  'Control who sees your activity, decide how your UniLane profile is shown, and review your safety settings.',
              icon: Icons.lock_outline_rounded,
              actionLabel: 'Review security',
              actionIcon: Icons.shield_outlined,
            ),
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
            onTap: () => _openSettings(
              context,
              title: 'Help Center',
              description:
                  'Find quick answers, common questions, and simple guides for using UniLane on campus.',
              icon: Icons.help_outline_rounded,
              actionLabel: 'Browse help',
              actionIcon: Icons.menu_book_outlined,
            ),
          ),
          SettingsTile(
            icon: Icons.report_gmailerrorred_outlined,
            label: 'Report a Problem',
            onTap: () => _openSettings(
              context,
              title: 'Report a Problem',
              description:
                  'Tell us what went wrong so we can help fix it and keep UniLane clean, safe, and useful.',
              icon: Icons.report_gmailerrorred_outlined,
              actionLabel: 'Send report',
              actionIcon: Icons.send_rounded,
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _LogoutTile(
              label: isSignedIn ? 'Log Out' : 'Log In',
              icon: isSignedIn ? Icons.logout_rounded : Icons.login_rounded,
              onTap: isSignedIn
                  ? () => _confirmLogout(context)
                  : () => _openLogin(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditProfile(
    BuildContext context,
    UserProfileItem profile,
  ) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );

    if (!context.mounted || saved != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated on UniLane'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openLogin(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const LoginScreen()));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out of UniLane?'),
          content: const Text(
            'You will be signed out of your campus account and can come back anytime.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || shouldLogout != true) {
      return;
    }

    await context.read<AuthProvider>().signOut();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openSettings(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    String? actionLabel,
    IconData? actionIcon,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SettingsDetailScreen(
          title: title,
          description: description,
          icon: icon,
          actionLabel: actionLabel,
          actionIcon: actionIcon,
          onActionPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.profile,
    required this.onEditProfile,
  });

  final UserProfileItem profile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFEAF2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFDDE8FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: const BoxDecoration(
                  color: Color(0xFF1D4ED8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.displayName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        TrustBadge(
                          label: profile.isVerifiedStudent
                              ? 'Verified student'
                              : 'Verification pending',
                          backgroundColor: profile.isVerifiedStudent
                              ? const Color(0xFFE8F8EF)
                              : const Color(0xFFFFF4E5),
                          foregroundColor: profile.isVerifiedStudent
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB45309),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.campus,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.contact,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.bio,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProfileInfoChip(
                icon: Icons.school_outlined,
                label: profile.level,
              ),
              _ProfileInfoChip(
                icon: Icons.location_on_outlined,
                label: profile.campus,
              ),
              _ProfileInfoChip(
                icon: Icons.schedule_rounded,
                label: profile.memberSince,
              ),
            ],
          ),
          if (profile.interests.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.interests
                  .map((interest) => _InterestChip(label: interest))
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit profile details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1D4ED8),
                side: const BorderSide(color: Color(0xFFBFD2FF)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestProfileCard extends StatelessWidget {
  const _GuestProfileCard({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 33,
                backgroundColor: Color(0xFFEAF2FF),
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF1D4ED8),
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete your UniLane profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sign in to manage your marketplace, stay connected, and keep your account details in one place.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSignIn,
              child: const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoChip extends StatelessWidget {
  const _ProfileInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDCE7FF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF1D4ED8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6EEFF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFECACA)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFFB91C1C), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF991B1B),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFDC2626)),
            ],
          ),
        ),
      ),
    );
  }
}
