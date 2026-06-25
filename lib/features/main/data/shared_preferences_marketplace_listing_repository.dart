import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/marketplace_listing_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class SharedPreferencesMarketplaceListingRepository
    implements MarketplaceListingRepository {
  static const String _savedListingsKey = 'saved_marketplace_listings';

  @override
  Future<List<ListingItem>> loadSavedListings() async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return const <ListingItem>[];
    } catch (_) {
      return const <ListingItem>[];
    }

    final rawListings = prefs.getStringList(_savedListingsKey) ?? <String>[];

    return rawListings
        .map((rawListing) {
          try {
            final decoded = jsonDecode(rawListing);
            if (decoded is Map<String, dynamic>) {
              return ListingItem.fromJson(decoded);
            }
          } catch (_) {
            // Ignore malformed saved data and keep the app running.
          }

          return null;
        })
        .whereType<ListingItem>()
        .toList();
  }

  @override
  Future<void> addListing(ListingItem listing) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return;
    } catch (_) {
      return;
    }

    final currentListings = await loadSavedListings();
    final updatedListings = <ListingItem>[listing, ...currentListings];
    final rawListings = updatedListings
        .map((item) => jsonEncode(item.toJson()))
        .toList();

    await prefs.setStringList(_savedListingsKey, rawListings);
  }
}
