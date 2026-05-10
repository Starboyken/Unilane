import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unitrade/core/widgets/app_search_field.dart';
import 'package:unitrade/features/main/data/campus_mart_mock_data.dart';
import 'package:unitrade/features/main/presentation/providers/campus_mart_provider.dart';
import 'package:unitrade/features/main/presentation/widgets/shared_widgets.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampusMartProvider>();
    final selectedCategory = provider.selectedServiceCategory;
    final query = provider.servicesSearchQuery.trim().toLowerCase();
    final filteredItems = serviceItems.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.provider.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.price.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          const Text(
            'Campus Services',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          AppSearchField(
            hintText: 'Search tutors, barbers, photographers...',
            value: provider.servicesSearchQuery,
            onChanged: context
                .read<CampusMartProvider>()
                .setServicesSearchQuery,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: servicesCategories
                        .map(
                          (label) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChipPill(
                              label: label,
                              isSelected: label == selectedCategory,
                              onTap: () {
                                context
                                    .read<CampusMartProvider>()
                                    .setServiceCategory(label);
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
              title: 'No matching services',
              message:
                  'Try another service name, provider, or category on campus.',
            )
          else
            ...filteredItems.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ServiceCard(service: service),
              ),
            ),
        ],
      ),
    );
  }
}
