library globals;

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

late TextTheme textTheme;


class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
  late SharedPreferences _prefs;

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _instance._prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _instance._prefs.getString(key);
  }

  // Similarly, you can add other methods for different data types (e.g., int, bool, etc.)
  static Future<void> setInt(String key, int value) async {
    await _instance._prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _instance._prefs.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _instance._prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _instance._prefs.getBool(key);
  }

// Add other methods as needed...
}

Widget loadingAnimation(
    // {required Color primaryColor, required Color secondaryColor, required Color thirdColor, double size = 50}
    ) {
  return Center(
    child: LoadingAnimationWidget.discreteCircle(
      color: m,
      secondRingColor: Colors.white70,
      thirdRingColor: sec,
      size: 50,
    ),
  );
}