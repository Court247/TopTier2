import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get instance => _prefs;

  // Save a preference for a specific user
  Future<void> saveUserPreference(
      String userId, String key, String value) async {
    String userSpecificKey = _getUserSpecificKey(userId, key);
    await _prefs.setString(userSpecificKey, value);
  }

  // Load a preference for a specific user
  Future<String?> getUserPreference(String userId, String key) async {
    String userSpecificKey = _getUserSpecificKey(userId, key);
    return _prefs.getString(userSpecificKey);
  }

  // Generate a user-specific key
  String _getUserSpecificKey(String userId, String key) {
    return '$userId:$key';
  }
}
