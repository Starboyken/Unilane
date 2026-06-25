import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilane/core/widgets/app_search_field.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/chat_detail_screen.dart';
import 'package:unilane/features/main/presentation/screens/roommate_detail_screen.dart';
import 'package:unilane/features/main/presentation/screens/post_roommate_request_screen.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class RoommatesScreen extends StatefulWidget {
  const RoommatesScreen({super.key});

  @override
  State<RoommatesScreen> createState() => _RoommatesScreenState();
}

class _RoommatesScreenState extends State<RoommatesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  static const List<String> _filters = <String>[
    'All',
    'Verified',
    'Near Campus',
    'Budget Friendly',
    'Female',
    'Male',
  ];

  @override
  Widget build(BuildContext context) {
    final roommateProfiles = context
        .watch<CampusMartProvider>()
        .roommateProfiles;
    final filteredProfiles = roommateProfiles.where((profile) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          profile.name.toLowerCase().contains(query) ||
          profile.area.toLowerCase().contains(query) ||
          profile.level.toLowerCase().contains(query) ||
          profile.about.toLowerCase().contains(query) ||
          profile.interests.any(
            (interest) => interest.toLowerCase().contains(query),
          );

      final matchesFilter = switch (_selectedFilter) {
        'All' => true,
        'Verified' => profile.isVerifiedStudent,
        'Near Campus' =>
          profile.area.contains('Rumuolumeni') ||
              profile.area.contains('Campus'),
        'Budget Friendly' =>
          profile.budget.contains('150k') || profile.budget.contains('180k'),
        'Female' => profile.genderPreference.toLowerCase().contains('female'),
        'Male' => profile.genderPreference.toLowerCase().contains('male'),
        _ => true,
      };

      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Row(
              children: [
                HeaderIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roommate Matches',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find students with similar budgets, schedules, and vibes.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.people_outline_rounded,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post your roommate request',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Share your budget, area, and moving date in one place.',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _openPostRequest(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Post Request'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppSearchField(
              hintText: 'Search names, areas, and interests...',
              value: _searchQuery,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChipPill(
                          label: filter,
                          isSelected: filter == _selectedFilter,
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: SectionHeading('Available Matches')),
                Text(
                  '${filteredProfiles.length} found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filteredProfiles.isEmpty)
              const EmptyStateCard(
                title: 'No roommate matches yet',
                message:
                    'Try a different filter, interest, or location to find more students.',
              )
            else
              ...filteredProfiles.map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _RoommateCard(
                    profile: profile,
                    onTap: () => _openRoommateDetails(context, profile),
                    onMessage: () => _messageRoommate(context, profile),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPostRequest(BuildContext context) async {
    final savedProfile = await Navigator.of(context).push<RoommateProfileItem>(
      MaterialPageRoute<RoommateProfileItem>(
        builder: (context) => const PostRoommateRequestScreen(),
      ),
    );

    if (!context.mounted || savedProfile == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${savedProfile.name} posted on UniLane'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openRoommateDetails(BuildContext context, RoommateProfileItem profile) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RoommateDetailScreen(profile: profile),
      ),
    );
  }

  void _messageRoommate(BuildContext context, RoommateProfileItem profile) {
    final firstName = profile.name.split(' ').first;
    final conversationId = context.read<CampusMartProvider>().ensureConversation(
      preferredId: 'roommate-${profile.id}',
      initials: profile.initials,
      name: profile.name,
      initialMessage:
          'Hi $firstName, I saw your roommate post on UniLane. Are you still looking?',
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChatDetailScreen(conversationId: conversationId),
      ),
    );
  }
}

class _RoommateCard extends StatelessWidget {
  const _RoommateCard({
    required this.profile,
    required this.onTap,
    required this.onMessage,
  });

  final RoommateProfileItem profile;
  final VoidCallback onTap;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFEAF2FF),
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
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
                              profile.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          if (profile.isVerifiedStudent)
                            const TrustBadge(label: 'Verified student'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.level} • ${profile.area}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CardChip(label: profile.budget),
                _CardChip(label: profile.moveIn),
                _CardChip(label: profile.genderPreference),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              profile.about,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.interests
                  .map((interest) => _InterestPill(label: interest))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: ValueKey('roommateView-${profile.id}'),
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('View profile'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    key: ValueKey('roommateMessage-${profile.id}'),
                    onPressed: onMessage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Message'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardChip extends StatelessWidget {
  const _CardChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

class _InterestPill extends StatelessWidget {
  const _InterestPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}
