import 'package:unilane/features/main/data/listing_media_repository.dart';

class LocalListingMediaRepository implements ListingMediaRepository {
  @override
  Future<String> resolveListingImageUrl({
    required String imageUrl,
    required String listingTitle,
    required String listingCategory,
    required String ownerId,
  }) async {
    return imageUrl;
  }
}
