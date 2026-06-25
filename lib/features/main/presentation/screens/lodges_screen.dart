import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unilane/core/widgets/app_search_field.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';
import 'package:unilane/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unilane/features/main/presentation/screens/add_listing_screen.dart';
import 'package:unilane/features/main/presentation/screens/product_detail_screen.dart';
import 'package:unilane/features/main/presentation/widgets/shared_widgets.dart';

class LodgesScreen extends StatefulWidget {
  const LodgesScreen({super.key});

  @override
  State<LodgesScreen> createState() => _LodgesScreenState();
}

class _LodgesScreenState extends State<LodgesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  static const List<String> _filters = <String>[
    'All',
    'Self-contained',
    'Mini flat',
    'Per year',
    'Per semester',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final lodgeListings = provider.marketplaceListings.where((item) {
      final isLodge = item.category == 'Lodges';
      final query = _searchQuery.trim().toLowerCase();
      final filter = _selectedFilter;
      final matchesFilter = switch (filter) {
        'All' => true,
        'Self-contained' =>
          item.roomType?.toLowerCase().contains('self-contained') ?? false,
        'Mini flat' =>
          item.roomType?.toLowerCase().contains('mini flat') ?? false,
        'Per year' =>
          item.rentDuration?.toLowerCase().contains('year') ?? false,
        'Per semester' =>
          item.rentDuration?.toLowerCase().contains('semester') ?? false,
        _ => true,
      };
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.price.toLowerCase().contains(query) ||
          item.sellerName.toLowerCase().contains(query);

      return isLodge && matchesFilter && matchesQuery;
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
                        'Find Student-Friendly Stays',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Browse lodges, compare prices, and chat with landlords.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.home_work_outlined, color: Color(0xFF4C9B58)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post a lodge students will actually like',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Show rent, location, and clean photos in one place.',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _openAddLodgeListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Post a Lodge'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppSearchField(
              hintText: 'Search lodges, rent, or area...',
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
            const SizedBox(height: 10),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LodgeTag(label: 'Verified'),
                _LodgeTag(label: 'Near Campus'),
                _LodgeTag(label: 'Available Now'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: SectionHeading('Available Stays')),
                Text(
                  '${lodgeListings.length} found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (lodgeListings.isEmpty)
              const EmptyStateCard(
                title: 'No lodge matches yet',
                message:
                    'Try another filter, area, or rent range, or post a lodge listing.',
              )
            else
              ...lodgeListings.map(
                (listing) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _LodgeListingCard(
                    listing: listing,
                    onTap: () => _openListingDetails(context, listing),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddLodgeListing() async {
    final addedListing = await Navigator.of(context).push<ListingItem>(
      MaterialPageRoute<ListingItem>(
        builder: (context) => const AddListingScreen(initialCategory: 'Lodges'),
      ),
    );

    if (!mounted || addedListing == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${addedListing.title} added to lodges'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openListingDetails(BuildContext context, ListingItem listing) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(listing: listing),
      ),
    );
  }
}

class _LodgeListingCard extends StatelessWidget {
  const _LodgeListingCard({required this.listing, required this.onTap});

  final ListingItem listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: NetworkImageBlock(
                imageUrl: listing.imageUrl,
                height: 108,
                width: 108,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listing.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        listing.badge!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF166534),
                        ),
                      ),
                    ),
                  if (listing.badge != null) const SizedBox(height: 8),
                  Text(
                    listing.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    listing.price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${listing.sellerName} • ${listing.postedTime}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (listing.isVerifiedSeller) ...[
                    const SizedBox(height: 8),
                    const TrustBadge(label: 'Verified landlord'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LodgeTag extends StatelessWidget {
  const _LodgeTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFE5E7EB)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
