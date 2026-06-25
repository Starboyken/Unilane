import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unilane/features/main/data/backend/uni_lane_backend_collections.dart';
import 'package:unilane/features/main/data/roommate_profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class FirestoreRoommateProfileRepository implements RoommateProfileRepository {
  FirestoreRoommateProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<RoommateProfileItem>> loadSavedRoommateProfiles() async {
    final snapshot = await _firestore
        .collection(UniLaneCollections.roommateProfiles)
        .orderBy(UniLaneDocumentFields.createdAt, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RoommateProfileItem.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> addRoommateProfile(RoommateProfileItem profile) async {
    final data = profile.toJson()
      ..[UniLaneDocumentFields.createdAt] = FieldValue.serverTimestamp()
      ..[UniLaneDocumentFields.updatedAt] = FieldValue.serverTimestamp();

    await _firestore
        .collection(UniLaneCollections.roommateProfiles)
        .doc(profile.id)
        .set(data, SetOptions(merge: true));
  }
}
