import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'CharacterRemove.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  SharedPreferences get instance => _prefs;

  // Save a preference for a specific user
  Future<void> saveUserFavorites(
      String userId, String key, List<CharacterRemove> value) async {
    await init();
    var specialString = getSpecialUserKey(userId, key);
    String jsonString = jsonEncode(
        value.map((characterRemove) => characterRemove.toJson()).toList());
    await _prefs.setString(specialString, jsonString);
  }

  // Load a preference for a specific user
  Future<List> getUserFavorites(String userId, String key) async {
    await init();
    List<CharacterRemove> favorites = [];
    var specialString = getSpecialUserKey(userId, key);
    String? jsonString = await _prefs.getString(specialString);
    if (jsonString != null) {
      var jsonResponse = jsonDecode(jsonString) as List;
      favorites =
          jsonResponse.map((json) => CharacterRemove.fromJson(json)).toList();
    }
    return favorites;
  }

  String getSpecialUserKey(String userId, String key) {
    return "$userId:$key";
  }

  Future<void> clearPreferences(userID, key) async {
    await init();
    var specialString = getSpecialUserKey(userID, key);
    await _prefs.remove(specialString);
  }
}
