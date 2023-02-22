import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences.setBool(key, value);
  }

  static bool? getData({
    required String key,
  }) {
    return sharedPreferences.getBool(key);
  }

  static setString({required String key, required String value}) async {
    return await sharedPreferences.setString(key, value);
  }

  static String? getString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }
}
