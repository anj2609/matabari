import 'package:shared_preferences/shared_preferences.dart';

/// Persists the logged-in session so the user stays signed in across app
/// restarts until they log out or uninstall the app.
class SessionPrefs {
  static const String _loggedInKey = 'is_logged_in';
  static const String _roleKey = 'user_role';
  static const String _nameKey = 'user_name';

  /// Returns true if a session was previously saved.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  /// The role of the last logged-in user ("seller" or "buyer").
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// The display name captured during login/registration.
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  /// Saves the display name captured during login/registration.
  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  /// Marks the session as logged in and remembers which dashboard to
  /// return to on the next app launch.
  static Future<void> setLoggedIn(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_roleKey, role);
  }

  /// Clears the saved session, requiring the user to log in again.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_nameKey);
  }

  /// Permanently wipes all locally stored data for this account. Since the
  /// app has no backend user store, this local cache is the account - so
  /// clearing every key (not just the session ones) is what "delete
  /// account" actually means here.
  static Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
