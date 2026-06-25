import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/roommate_profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

class SharedPreferencesRoommateProfileRepository
    implements RoommateProfileRepository {
  static const String _savedRoommateProfilesKey = 'saved_roommate_profiles';

  @override
  Future<List<RoommateProfileItem>> loadSavedRoommateProfiles() async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return const <RoommateProfileItem>[];
    } catch (_) {
      return const <RoommateProfileItem>[];
    }

    final rawProfiles =
        prefs.getStringList(_savedRoommateProfilesKey) ?? <String>[];

    return rawProfiles
        .map((rawProfile) {
          try {
            final decoded = jsonDecode(rawProfile);
            if (decoded is Map) {
              return RoommateProfileItem.fromJson(
                Map<String, dynamic>.from(decoded),
              );
            }
          } catch (_) {
            // Ignore malformed saved data and keep the app running.
          }

          return null;
        })
        .whereType<RoommateProfileItem>()
        .toList();
  }

  @override
  Future<void> addRoommateProfile(RoommateProfileItem profile) async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return;
    } catch (_) {
      return;
    }

    final currentProfiles = await loadSavedRoommateProfiles();
    final updatedProfiles = <RoommateProfileItem>[profile, ...currentProfiles];
    final rawProfiles = updatedProfiles
        .map((savedProfile) => jsonEncode(savedProfile.toJson()))
        .toList();

    await prefs.setStringList(_savedRoommateProfilesKey, rawProfiles);
  }
}
