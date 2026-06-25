import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unilane/features/main/data/backend/uni_lane_backend_collections.dart';
import 'package:unilane/features/main/data/conversation_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class FirestoreConversationRepository implements ConversationRepository {
  FirestoreConversationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<ConversationItem>> loadConversations({String? userId}) async {
    final snapshot = await _conversationsCollection(userId)
        .orderBy(UniLaneDocumentFields.sortOrder)
        .get();

    return snapshot.docs
        .map((doc) => ConversationItem.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> saveConversations(
    List<ConversationItem> conversations, {
    String? userId,
  }) async {
    final batch = _firestore.batch();
    final collection = _conversationsCollection(userId);

    for (var index = 0; index < conversations.length; index++) {
      final conversation = conversations[index];
      final data = conversation.toJson()
        ..[UniLaneDocumentFields.sortOrder] = index
        ..[UniLaneDocumentFields.updatedAt] = FieldValue.serverTimestamp();

      batch.set(collection.doc(conversation.id), data);
    }

    await batch.commit();
  }

  CollectionReference<Map<String, dynamic>> _conversationsCollection(
    String? userId,
  ) {
    final normalizedUserId = userId == null || userId.trim().isEmpty
        ? 'guest'
        : userId.trim();

    return _firestore
        .collection(UniLaneCollections.users)
        .doc(normalizedUserId)
        .collection(UniLaneCollections.conversations);
  }
}
