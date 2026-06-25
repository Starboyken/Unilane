import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/chat_detail_screen.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.listing});

  final ListingItem listing;

  bool get _isLodgeListing => listing.category == 'Lodges';

  String get _aboutHeading =>
      _isLodgeListing ? 'About this stay' : 'About this listing';

  String get _detailsHeading =>
      _isLodgeListing ? 'Stay details' : 'Quick details';

  String get _infoHeading => _isLodgeListing
      ? 'Need more information about this stay?'
      : 'Need more information?';

  String get _messageButtonLabel =>
      _isLodgeListing ? 'Message Landlord' : 'Message Seller';

  bool get _hasLodgeSpecificDetails =>
      listing.roomType != null ||
      listing.rentDuration != null ||
      listing.utilities != null ||
      listing.distanceToCampus != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    NetworkImageBlock(imageUrl: listing.imageUrl, height: 320),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x66000000),
                              Color(0x14000000),
                              Color(0x66000000),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            HeaderIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (listing.badge != null)
                      Positioned(
                        left: 16,
                        bottom: 18,
                        child: _DetailBadge(
                          label: listing.badge!,
                          isUrgent: listing.badge == 'Urgent Sale',
                        ),
                      ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoChip(
                              icon: Icons.sell_outlined,
                              label: listing.category,
                            ),
                            _InfoChip(
                              icon: Icons.verified_outlined,
                              label: listing.condition,
                            ),
                            _InfoChip(
                              icon: Icons.schedule_outlined,
                              label: listing.postedTime,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          listing.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          listing.price,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                listing.location,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _SellerCard(
                          listing: listing,
                          onMessageSeller: () => _openChat(context),
                        ),
                        if (_isLodgeListing && listing.isVerifiedSeller) ...[
                          const SizedBox(height: 14),
                          const TrustBadge(label: 'Verified landlord'),
                        ],
                        const SizedBox(height: 24),
                        Text(
                          _aboutHeading,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          listing.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _detailsHeading,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(label: 'Seller', value: listing.sellerName),
                        _DetailRow(label: 'Role', value: listing.sellerRole),
                        _DetailRow(label: 'Category', value: listing.category),
                        _DetailRow(
                          label: 'Condition',
                          value: listing.condition,
                        ),
                        if (_isLodgeListing && _hasLodgeSpecificDetails) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Lodge specifics',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (listing.roomType != null)
                            _DetailRow(
                              label: 'Room type',
                              value: listing.roomType!,
                            ),
                          if (listing.rentDuration != null)
                            _DetailRow(
                              label: 'Rent duration',
                              value: listing.rentDuration!,
                            ),
                          if (listing.utilities != null)
                            _DetailRow(
                              label: 'Utilities included',
                              value: listing.utilities!,
                            ),
                          if (listing.distanceToCampus != null)
                            _DetailRow(
                              label: 'Distance to campus',
                              value: listing.distanceToCampus!,
                            ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _infoHeading,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openChat(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: const Icon(Icons.chat_bubble_rounded),
                      label: Text(_messageButtonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context) {
    final conversationId = context
        .read<CampusMartProvider>()
        .ensureConversation(
          preferredId: _buildConversationId(listing.sellerName),
          initials: _buildInitials(listing.sellerName),
          name: listing.sellerName,
          initialMessage: _openingMessage,
        );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChatDetailScreen(conversationId: conversationId),
      ),
    );
  }

  String get _openingMessage => _isLodgeListing
      ? 'Hi, is "${listing.title}" still available for students on UniLane?'
      : 'Hi, is "${listing.title}" still available on UniLane?';

  String _buildInitials(String name) {
    final parts = _normalizedNameParts(name);

    if (parts.isEmpty) {
      return 'UL';
    }

    if (parts.length == 1) {
      final part = parts.first;

      return part.length >= 2
          ? part.substring(0, 2).toUpperCase()
          : part.toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _buildConversationId(String name) {
    final parts = _normalizedNameParts(name);

    if (parts.isEmpty) {
      return 'unilane-chat';
    }

    return parts.join('-').toLowerCase();
  }

  List<String> _normalizedNameParts(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z ]'), ' ').trim();

    if (cleaned.isEmpty) {
      return const [];
    }

    return cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
  }
}

class _DetailBadge extends StatelessWidget {
  const _DetailBadge({required this.label, required this.isUrgent});

  final String label;
  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFF111827),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.listing, required this.onMessageSeller});

  final ListingItem listing;
  final VoidCallback onMessageSeller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFDBEAFE),
            child: Text(
              _buildInitials(listing.sellerName),
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.sellerName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  listing.sellerRole,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onMessageSeller, child: const Text('Chat')),
        ],
      ),
    );
  }

  String _buildInitials(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z ]'), ' ').trim();

    if (cleaned.isEmpty) {
      return 'UL';
    }

    final parts = cleaned
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length == 1) {
      final part = parts.first;

      return part.length >= 2
          ? part.substring(0, 2).toUpperCase()
          : part.toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
