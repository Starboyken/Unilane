import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unilane/features/main/data/backend/uni_lane_backend_collections.dart';
import 'package:unilane/features/main/data/profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class FirestoreProfileRepository implements UserProfileRepository {
  FirestoreProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<UserProfileItem?> loadProfile({required String userId}) async {
    final snapshot = await _firestore
        .collection(UniLaneCollections.users)
        .doc(userId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return UserProfileItem.fromJson(data);
  }

  @override
  Future<void> saveProfile(UserProfileItem profile) async {
    final data = profile.toJson()
      ..[UniLaneDocumentFields.updatedAt] = FieldValue.serverTimestamp();

    await _firestore
        .collection(UniLaneCollections.users)
        .doc(profile.userId)
        .set(data, SetOptions(merge: true));
  }
}
