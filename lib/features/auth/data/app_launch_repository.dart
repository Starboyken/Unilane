abstract class AppLaunchRepository {
  Future<bool> hasSeenOnboarding();

  Future<void> markOnboardingSeen();
}
