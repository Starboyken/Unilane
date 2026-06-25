import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class SharedPreferencesProfileRepository implements UserProfileRepository {
  String _storageKey(String userId) => 'saved_user_profile_$userId';

  @override
  Future<UserProfileItem?> loadProfile({required String userId}) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return null;
    } catch (_) {
      return null;
    }

    final rawProfile = prefs.getString(_storageKey(userId));
    if (rawProfile == null || rawProfile.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawProfile);
      if (decoded is Map<String, dynamic>) {
        return UserProfileItem.fromJson(decoded);
      }
    } catch (_) {
      // Ignore malformed saved data and keep the app running.
    }

    return null;
  }

  @override
  Future<void> saveProfile(UserProfileItem profile) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return;
    } catch (_) {
      return;
    }

    await prefs.setString(
      _storageKey(profile.userId),
      jsonEncode(profile.toJson()),
    );
  }
}
