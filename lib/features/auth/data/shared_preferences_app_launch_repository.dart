import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/auth/data/app_launch_repository.dart';

class SharedPreferencesAppLaunchRepository implements AppLaunchRepository {
  static const String _seenOnboardingKey = 'seen_onboarding';

  @override
  Future<bool> hasSeenOnboarding() async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }

    return prefs.getBool(_seenOnboardingKey) ?? false;
  }

  @override
  Future<void> markOnboardingSeen() async {
    late final SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } on MissingPluginException {
      return;
    } catch (_) {
      return;
    }

    await prefs.setBool(_seenOnboardingKey, true);
  }
}
