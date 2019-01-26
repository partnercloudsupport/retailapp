import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static Future<String> getLanguageApp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('languageApp') ?? 'en-US';
  }

  static Future<Null> setLanguageApp(String v) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('languageApp', v);
  }

  static Future<String> getUserName() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userName') ?? '';
  }

  static Future<Null> setUserName(String v) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userName', v);
  }

  static Future<String> getUserPassword() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userPassword') ?? '';
  }

  static Future<Null> setUserPassword(String v) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userPassword', v);
  }

  static Future<String> getRequestFilterEmployee() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('RequestFilterEmployee') ?? '';
  }

  static Future<Null> setRequestFilterEmployee(String v) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('RequestFilterEmployee', v);
  }
}
