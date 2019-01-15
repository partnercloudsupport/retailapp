import 'package:intl/intl.dart';

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

String betweenBrackets(String v) {
  return '(' + v + ')';
}

String getExtension(String v) {
  return v.split('.').last;
}

String getExtensionWithDot(String v) {
  String o = v.split('.').last;
  return o.isEmpty ? '' : '.' + o;
}

String formatNumber(dynamic v, {String pattern = '0'}) {
  return NumberFormat(pattern).format(v);
}

String toMe(dynamic v) {
  try {
    return v == null ? '' : v.toString();
  } catch (e) {}
  return '';
}

String toMef(var v) {
  try {
    return v == null ? '' : v.toString();
  } catch (e) {}
  return '';
}
