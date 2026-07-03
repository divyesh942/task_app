import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._(this.prefs);

  final SharedPreferences prefs;

  static Preferences? _instance;

  factory Preferences() {
    if (_instance == null) {
      throw ("Preferences is not initialized");
    } else {
      return Preferences._instance!;
    }
  }

  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Preferences._instance = Preferences._(prefs);
  }

  Future<void> setData(String key, Object value) async {
    if (value is int) {
      await prefs.setInt(key, value);
      return;
    }
    if (value is String) {
      await prefs.setString(key, value);
      return;
    }
    if (value is bool) {
      await prefs.setBool(key, value);
      return;
    }
    if (value is double) {
      await prefs.setDouble(key, value);
      return;
    }
    if (value is List<String>) {
      await prefs.setStringList(key, value);
      return;
    }

    throw UnsupportedError('Unsupported preference type: ${value.runtimeType}');
  }

  Object? getData(String key) {
    return prefs.get(key);
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  Future<void> clearData() async {
    await prefs.clear();
  }
}
