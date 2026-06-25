import 'package:unilane/features/main/models/campus_mart_models.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> loadNotifications({String? userId});
  Future<void> saveNotifications(
    List<NotificationItem> notifications, {
    String? userId,
  });
}
