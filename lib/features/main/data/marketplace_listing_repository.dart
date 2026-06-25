import 'package:unilane/features/main/models/campus_mart_models.dart';

abstract class MarketplaceListingRepository {
  Future<List<ListingItem>> loadSavedListings();
  Future<void> addListing(ListingItem listing);
}
