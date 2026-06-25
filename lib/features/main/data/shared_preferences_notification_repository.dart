import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/notification_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class SharedPreferencesNotificationRepository
    implements NotificationRepository {
  static const String _savedNotificationsKey = 'saved_notifications';

  String _storageKey(String? userId) {
    final normalizedUserId = userId == null || userId.trim().isEmpty
        ? 'guest'
        : userId.trim();

    return '${_savedNotificationsKey}_$normalizedUserId';
  }

  @override
  Future<List<NotificationItem>> loadNotifications({String? userId}) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return const <NotificationItem>[];
    } catch (_) {
      return const <NotificationItem>[];
    }

    final rawNotifications =
        prefs.getStringList(_storageKey(userId)) ?? <String>[];

    return rawNotifications
        .map((rawNotification) {
          try {
            final decoded = jsonDecode(rawNotification);
            if (decoded is Map<String, dynamic>) {
              return NotificationItem.fromJson(decoded);
            }
          } catch (_) {
            // Ignore malformed saved data and keep the app running.
          }

          return null;
        })
        .whereType<NotificationItem>()
        .toList();
  }

  @override
  Future<void> saveNotifications(
    List<NotificationItem> notifications, {
    String? userId,
  }) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return;
    } catch (_) {
      return;
    }

    final rawNotifications = notifications
        .map((notification) => jsonEncode(notification.toJson()))
        .toList();

    await prefs.setStringList(_storageKey(userId), rawNotifications);
  }
}
