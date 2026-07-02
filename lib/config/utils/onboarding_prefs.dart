import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the onboarding flow has already been shown.
/// The onboarding screens should appear only on the first app launch.
class OnboardingPrefs {
  static const String _seenKey = 'onboarding_seen';

  /// Returns true if the user has already completed/skipped onboarding.
  static Future<bool> hasSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }

  /// Marks onboarding as seen so it is never shown again.
  static Future<void> setSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }
}
