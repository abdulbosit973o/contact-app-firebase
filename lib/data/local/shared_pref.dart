import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/contact_data.dart';
import 'constant.dart';

class SharedPreferencesHelper {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  Future<void> setString(String key, String value) async {
    _prefs.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    _prefs.setBool(key, value);
  }

// Get a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> delete() {
    return _prefs.clear();
  }

// Other methods remain the same...
}
