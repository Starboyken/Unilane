import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:unilane/features/main/data/shared_preferences_roommate_profile_repository.dart';
import 'package:unilane/features/main/models/campus_mart_models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('roommate repository round-trips saved requests', () async {
    final repository = SharedPreferencesRoommateProfileRepository();
    final profile = RoommateProfileItem(
      id: 'roommate-1',
      initials: 'BO',
      name: 'Blessing Okafor',
      level: '300-level',
      area: 'Rumuolumeni',
      budget: 'Up to N180k/year',
      moveIn: 'August',
      genderPreference: 'Female roommate',
      interests: const ['Cooking', 'Quiet study', 'Reading'],
      about: 'Looking for a calm and neat roommate near IAUE.',
      isVerifiedStudent: true,
    );

    await repository.addRoommateProfile(profile);

    final loadedProfiles = await repository.loadSavedRoommateProfiles();

    expect(loadedProfiles, hasLength(1));
    expect(loadedProfiles.first.id, 'roommate-1');
    expect(loadedProfiles.first.name, 'Blessing Okafor');
    expect(loadedProfiles.first.isVerifiedStudent, isTrue);
  });
}
