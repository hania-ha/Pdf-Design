import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    await init();
    return _preferences!.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    await init();
    return _preferences!.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  static Future<bool> setInt(String key, int value) async {
    await init();
    return _preferences!.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) async {
    await init();
    return _preferences!.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    await init();
    return _preferences!.setStringList(key, value);
  }

  static List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _preferences?.getStringList(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    await init();
    return _preferences!.remove(key);
  }

  static Future<bool> clear() async {
    await init();
    return _preferences!.clear();
  }
}
