import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  late SharedPreferences sharedPreferences;

  Future<bool> remove() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }

  Future<bool> setPref(String key, String value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, value);
  }

  Future<String> getPref(String key) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? " ";
  }

}