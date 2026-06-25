import 'package:unilane/features/main/models/campus_mart_models.dart';

abstract class RoommateProfileRepository {
  Future<List<RoommateProfileItem>> loadSavedRoommateProfiles();

  Future<void> addRoommateProfile(RoommateProfileItem profile);
}
