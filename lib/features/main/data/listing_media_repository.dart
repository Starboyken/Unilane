abstract class ListingMediaRepository {
  Future<String> resolveListingImageUrl({
    required String imageUrl,
    required String listingTitle,
    required String listingCategory,
    required String ownerId,
  });
}
