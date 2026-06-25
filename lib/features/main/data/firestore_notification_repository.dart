import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:unilane/features/main/data/backend/uni_lane_backend_collections.dart';
import 'package:unilane/features/main/data/notification_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class FirestoreNotificationRepository implements NotificationRepository {
  FirestoreNotificationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<NotificationItem>> loadNotifications({String? userId}) async {
    final snapshot = await _notificationsCollection(
      userId,
    ).orderBy(UniLaneDocumentFields.sortOrder).get();

    return snapshot.docs
        .map((doc) => NotificationItem.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> saveNotifications(
    List<NotificationItem> notifications, {
    String? userId,
  }) async {
    final batch = _firestore.batch();
    final collection = _notificationsCollection(userId);

    for (var index = 0; index < notifications.length; index++) {
      final notification = notifications[index];
      final data = notification.toJson()
        ..[UniLaneDocumentFields.sortOrder] = index
        ..[UniLaneDocumentFields.updatedAt] = FieldValue.serverTimestamp();

      batch.set(collection.doc(notification.id), data);
    }

    await batch.commit();
  }

  CollectionReference<Map<String, dynamic>> _notificationsCollection(
    String? userId,
  ) {
    final normalizedUserId = userId == null || userId.trim().isEmpty
        ? 'guest'
        : userId.trim();

    return _firestore
        .collection(UniLaneCollections.users)
        .doc(normalizedUserId)
        .collection(UniLaneCollections.notifications);
  }
}
