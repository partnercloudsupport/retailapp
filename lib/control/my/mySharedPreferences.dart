import 'package:shared_preferences/shared_preferences.dart';

Future<String> getLanguageApp() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('languageApp') ?? 'en-US';
}

Future<Null> setLanguageApp(String v) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('languageApp', v);
}

Future<String> getUserName() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('userName') ?? '';
}

Future<Null> setUserName(String v) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('userName', v);
}

Future<String> getUserPassword() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('userPassword') ?? '';
}

Future<Null> setUserPassword(String v) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('userPassword', v);
}
