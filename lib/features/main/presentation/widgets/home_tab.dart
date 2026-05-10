import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unitrade/core/widgets/app_search_field.dart';
import 'package:unitrade/features/main/data/campus_mart_mock_data.dart';
import 'package:unitrade/features/main/models/campus_mart_models.dart';
import 'package:unitrade/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unitrade/features/main/presentation/screens/product_detail_screen.dart';
import 'package:unitrade/features/main/presentation/widgets/shared_widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onOpenNotifications});

  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final query = provider.homeSearchQuery.trim().toLowerCase();
    final filteredCategories = homeCategories
        .where((item) => item.label.toLowerCase().contains(query))
        .toList();
    final filteredListings = featuredListings
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query),
        )
        .toList();
    final filteredRecommendations = recommendationItems
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.subtitle.toLowerCase().contains(query),
        )
        .toList();
    final hasQuery = query.isNotEmpty;
    final hasResults =
        filteredCategories.isNotEmpty ||
        filteredListings.isNotEmpty ||
        filteredRecommendations.isNotEmpty;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UniLane',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'University of Lagos',
                      style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              NotificationButton(onTap: onOpenNotifications),
            ],
          ),
          const SizedBox(height: 18),
          AppSearchField(
            hintText: 'Search deals, stays, services...',
            value: provider.homeSearchQuery,
            onChanged: context.read<CampusMartProvider>().setHomeSearchQuery,
          ),
          const SizedBox(height: 24),
          if (hasQuery && !hasResults)
            const EmptyStateCard(
              title: 'No UniLane matches yet',
              message:
                  'Try another keyword for listings, stays, or services on campus.',
            ),
          if (!hasQuery || filteredCategories.isNotEmpty) ...[
            const SectionHeading('Explore UniLane'),
            const SizedBox(height: 14),
            GridView.builder(
              itemCount: filteredCategories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];

                return CategoryCard(
                  category: category,
                  onTap: () => _openCategory(context, category),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
          if (!hasQuery)
            PromoCard(
              onPressed: () {
                context.read<CampusMartProvider>().openMarketplace();
              },
            ),
          if (!hasQuery) const SizedBox(height: 24),
          if (!hasQuery || filteredListings.isNotEmpty) ...[
            Row(
              children: [
                const Expanded(child: SectionHeading('Fresh on Campus')),
                TextButton(
                  onPressed: () {
                    context.read<CampusMartProvider>().openMarketplace();
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GridView.builder(
              itemCount: filteredListings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final listing = filteredListings[index];

                return ListingCard(
                  listing: listing,
                  onTap: () => _openListingDetails(context, listing),
                );
              },
            ),
            const SizedBox(height: 22),
          ],
          if (!hasQuery || filteredRecommendations.isNotEmpty) ...[
            const SectionHeading('Good Fits for You'),
            const SizedBox(height: 12),
            ...filteredRecommendations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecommendationCard(
                  item: item,
                  onTap: () => _openRecommendation(context, item),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openCategory(BuildContext context, CategoryItem category) {
    final provider = context.read<CampusMartProvider>();

    if (category.targetTabIndex == 1) {
      provider.openMarketplace(category: category.targetFilter);
      return;
    }

    if (category.targetTabIndex == 2) {
      provider.openServices(category: category.targetFilter);
      return;
    }

    if (category.targetTabIndex == 3) {
      provider.openMessages();
    }
  }

  void _openRecommendation(BuildContext context, RecommendationItem item) {
    final provider = context.read<CampusMartProvider>();

    if (item.targetTabIndex == 1) {
      provider.openMarketplace(category: item.targetFilter);
      return;
    }

    if (item.targetTabIndex == 2) {
      provider.openServices(category: item.targetFilter);
      return;
    }

    if (item.targetTabIndex == 3) {
      provider.openMessages();
    }
  }

  void _openListingDetails(BuildContext context, ListingItem listing) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(listing: listing),
      ),
    );
  }
}
