import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unitrade/core/widgets/app_search_field.dart';
import 'package:unitrade/features/main/data/campus_mart_mock_data.dart';
import 'package:unitrade/features/main/models/campus_mart_models.dart';
import 'package:unitrade/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unitrade/features/main/presentation/screens/product_detail_screen.dart';
import 'package:unitrade/features/main/presentation/widgets/shared_widgets.dart';

class MarketplaceTab extends StatelessWidget {
  const MarketplaceTab({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final selectedCategory = provider.selectedMarketplaceCategory;
    final query = provider.marketplaceSearchQuery.trim().toLowerCase();
    final filteredItems = marketplaceListings.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.price.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          Row(
            children: [
              HeaderIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBack,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'UniLane Market',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFF374151),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppSearchField(
            hintText: 'Search books, gadgets, clothes...',
            value: provider.marketplaceSearchQuery,
            onChanged: context
                .read<CampusMartProvider>()
                .setMarketplaceSearchQuery,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: marketplaceCategories
                        .map(
                          (label) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChipPill(
                              label: label,
                              isSelected: label == selectedCategory,
                              onTap: () {
                                context
                                    .read<CampusMartProvider>()
                                    .setMarketplaceCategory(label);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const SquareActionButton(icon: Icons.tune_rounded),
            ],
          ),
          const SizedBox(height: 18),
          if (filteredItems.isEmpty)
            const EmptyStateCard(
              title: 'No matching listings',
              message:
                  'Try another item name, location, or category on UniLane.',
            )
          else
            GridView.builder(
              itemCount: filteredItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final listing = filteredItems[index];

                return ListingCard(
                  listing: listing,
                  onTap: () => _openListingDetails(context, listing),
                );
              },
            ),
        ],
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
