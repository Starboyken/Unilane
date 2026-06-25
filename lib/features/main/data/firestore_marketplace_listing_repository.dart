import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unilane/features/main/data/backend/uni_lane_backend_collections.dart';
import 'package:unilane/features/main/data/marketplace_listing_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class FirestoreMarketplaceListingRepository
    implements MarketplaceListingRepository {
  FirestoreMarketplaceListingRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ListingItem>> loadSavedListings() async {
    final snapshot = await _firestore
        .collection(UniLaneCollections.listings)
        .orderBy(UniLaneDocumentFields.createdAt, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ListingItem.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> addListing(ListingItem listing) async {
    final data = listing.toJson()
      ..[UniLaneDocumentFields.createdAt] = FieldValue.serverTimestamp()
      ..[UniLaneDocumentFields.updatedAt] = FieldValue.serverTimestamp();

    await _firestore.collection(UniLaneCollections.listings).add(data);
  }
}
