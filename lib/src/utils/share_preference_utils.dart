import 'package:shared_preferences/shared_preferences.dart';


Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future saveValue(String key, Object value) async {
  SharedPreferences prefs = await _prefs;

  if (value is String) {
    await prefs.setString(key, value);
  } else if (value is int) {
    await prefs.setInt(key, value);
  } else if (value is bool) {
    await prefs.setBool(key, value);
  } else if (value is double) {
    await prefs.setDouble(key, value);
  } else if(value is List<String>){
    await prefs.setStringList(key, value);
  }
}

Future<String?> getString(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getString(key);
}

Future<int?> getInt(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getInt(key);
}

Future<double?> getDouble(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getDouble(key);
}

Future<bool?> getBoolean(String key) async {
  SharedPreferences prefs = await _prefs;
  return prefs.getBool(key);
}

Future removeValue(String key) async {
  SharedPreferences prefs = await _prefs;

  prefs.remove(key);
}

Future removeAll() async{
  SharedPreferences prefs = await _prefs;

  prefs.clear();
}




