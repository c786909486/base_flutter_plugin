import 'package:shared_preferences/shared_preferences.dart';


Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<bool> saveValue(String key, Object value) async {
  SharedPreferences prefs = await _prefs;

  if (value is String) {
   return await prefs.setString(key, value);
  } else if (value is int) {
    return await prefs.setInt(key, value);
  } else if (value is bool) {
    return await prefs.setBool(key, value);
  } else if (value is double) {
    return  await prefs.setDouble(key, value);
  } else {
    return await prefs.setStringList(key, value as List<String>);
  }
}

Future<String> getString(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getString(key);
}

Future<int> getInt(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getInt(key);
}

Future<double> getDouble(String key) async {
  SharedPreferences prefs = await _prefs;

  return prefs.getDouble(key);
}

Future<bool> getBoolean(String key) async {
  SharedPreferences prefs = await _prefs;
  return prefs.getBool(key);
}

Future removeValue(String key) async {
  SharedPreferences prefs = await _prefs;

  prefs.remove(key);
}

Future removeAllValue() async{
  SharedPreferences prefs = await _prefs;

  prefs.clear();
}




