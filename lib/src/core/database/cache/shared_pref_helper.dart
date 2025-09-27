import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  // متغير لحفظ instance من SharedPreferences
  static SharedPreferences? _prefs;

  // دالة لتهيئة SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Removes a value from SharedPreferences with given [key].
  static Future<void> removeData(String key) async {
    try {
      debugPrint('SharedPrefHelper : data with key : $key has been removed');
      await _prefs?.remove(key);
    } catch (e) {
      debugPrint("Error removing data: $e");
    }
  }

  /// Removes all keys and values in the SharedPreferences
  static Future<void> clearAllData() async {
    try {
      debugPrint('SharedPrefHelper : all data has been cleared');
      await _prefs?.clear();
    } catch (e) {
      debugPrint("Error clearing all data: $e");
    }
  }

  /// Saves a [value] with a [key] in the SharedPreferences.
  static Future<void> setData(String key, dynamic value) async {
    try {
      debugPrint(
        "SharedPrefHelper : setData with key : $key and value : $value",
      );

      switch (value.runtimeType) {
        case String:
          await _prefs?.setString(key, value);
          break;
        case int:
          await _prefs?.setInt(key, value);
          break;
        case bool:
          await _prefs?.setBool(key, value);
          break;
        case double:
          await _prefs?.setDouble(key, value);
          break;
        default:
          debugPrint("Unsupported data type: ${value.runtimeType}");
          return;
      }
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  /// Gets a bool value from SharedPreferences with given [key] - SYNCHRONOUS
  static bool getBool(String key) {
    try {
      debugPrint('SharedPrefHelper : getBool with key : $key');
      return _prefs?.getBool(key) ?? false;
    } catch (e) {
      debugPrint("Error getting bool: $e");
      return false;
    }
  }

  /// Gets a double value from SharedPreferences with given [key] - SYNCHRONOUS
  static double getDouble(String key) {
    try {
      debugPrint('SharedPrefHelper : getDouble with key : $key');
      return _prefs?.getDouble(key) ?? 0.0;
    } catch (e) {
      debugPrint("Error getting double: $e");
      return 0.0;
    }
  }

  /// Gets an int value from SharedPreferences with given [key] - SYNCHRONOUS
  static int getInt(String key) {
    try {
      debugPrint('SharedPrefHelper : getInt with key : $key');
      return _prefs?.getInt(key) ?? 0;
    } catch (e) {
      debugPrint("Error getting int: $e");
      return 0;
    }
  }

  /// Gets a String value from SharedPreferences with given [key] - SYNCHRONOUS
  static String getString(String key) {
    try {
      debugPrint('SharedPrefHelper : getString with key : $key');
      return _prefs?.getString(key) ?? '';
    } catch (e) {
      debugPrint("Error getting string: $e");
      return '';
    }
  }
}
