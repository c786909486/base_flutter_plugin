import 'package:shared_preferences/shared_preferences.dart';

Future saveValue(String key, Object value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value is String) {
    prefs.setString(key, value);
  } else if (value is int) {
    prefs.setInt(key, value);
  } else if (value is bool) {
    prefs.setBool(key, value);
  } else if (value is double) {
    prefs.setDouble(key, value);
  } else {
    prefs.setStringList(key, value);
  }
}

Future<String> getString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<int> getInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future<double> getDouble(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

Future remove(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future removeAll() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}




