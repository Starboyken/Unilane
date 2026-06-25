import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/conversation_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class SharedPreferencesConversationRepository
    implements ConversationRepository {
  static const String _savedConversationsKey = 'saved_conversations';

  String _storageKey(String? userId) {
    final normalizedUserId = userId == null || userId.trim().isEmpty
        ? 'guest'
        : userId.trim();

    return '${_savedConversationsKey}_$normalizedUserId';
  }

  @override
  Future<List<ConversationItem>> loadConversations({String? userId}) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return const <ConversationItem>[];
    } catch (_) {
      return const <ConversationItem>[];
    }

    final rawConversations =
        prefs.getStringList(_storageKey(userId)) ?? <String>[];

    return rawConversations
        .map((rawConversation) {
          try {
            final decoded = jsonDecode(rawConversation);
            if (decoded is Map) {
              return ConversationItem.fromJson(
                Map<String, dynamic>.from(decoded),
              );
            }
          } catch (_) {
            // Ignore malformed saved data and keep the app running.
          }

          return null;
        })
        .whereType<ConversationItem>()
        .toList();
  }

  @override
  Future<void> saveConversations(
    List<ConversationItem> conversations, {
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

    final rawConversations = conversations
        .map((conversation) => jsonEncode(conversation.toJson()))
        .toList();

    await prefs.setStringList(_storageKey(userId), rawConversations);
  }
}
