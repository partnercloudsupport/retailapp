import 'package:intl/intl.dart';

class MyString {
  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  static String betweenBrackets(String v) {
    return '(' + v + ')';
  }

  static String getExtension(String v) {
    return v.split('.').last;
  }

  static String getExtensionWithDot(String v) {
    String o = v.split('.').last;
    return o.isEmpty ? '' : '.' + o;
  }

  static String formatNumber(dynamic v, {String pattern = '0'}) {
    return NumberFormat(pattern).format(v);
  }

  static String toMe(dynamic v) {
    try {
      return v == null ? '' : v.toString();
    } catch (e) {}
    return '';
  }

  static String toMef(var v) {
    try {
      return v == null ? '' : v.toString();
    } catch (e) {}
    return '';
  }

  static String addEnterIfNotEmpty(String v) {
    return v.trim().isNotEmpty ? v + '\n' : '';
  }

  static String insertEnterIfNotEmpty(String v) {
    return v.trim().isNotEmpty ? '\n' + v : '';
  }
}
