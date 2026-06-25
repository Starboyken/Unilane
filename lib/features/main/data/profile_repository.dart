import 'package:unilane/features/main/models/campus_mart_models.dart';

abstract class UserProfileRepository {
  Future<UserProfileItem?> loadProfile({required String userId});

  Future<void> saveProfile(UserProfileItem profile);
}
