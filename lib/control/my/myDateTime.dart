import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MyDateTimeFormatTypes { hhmma, kkmm, ddMMyyyy, ddMMyyyykk, ddMMyyyykkmm, ddMMyyyyhhmma }

class MyDateTime {
  static String castTypesFormat(MyDateTimeFormatTypes t) {
    switch (t) {
      case MyDateTimeFormatTypes.hhmma:
        return 'hh:mm a';
        break;
      case MyDateTimeFormatTypes.kkmm:
        return 'kk:mm';
        break;
      case MyDateTimeFormatTypes.ddMMyyyy:
        return 'dd-MM-yyyy';
        break;
      case MyDateTimeFormatTypes.ddMMyyyykk:
        return 'dd-MM-yyyy – kk';
        break;
      case MyDateTimeFormatTypes.ddMMyyyykkmm:
        return 'dd-MM-yyyy – kk:mm';
        break;
      case MyDateTimeFormatTypes.ddMMyyyyhhmma:
        return 'dd-MM-yyyy – hh:mm a';
        break;
      default:
        {
          return 'dd-MM-yyyy – hh:mm a';
        }
        break;
    }
  }

  static String format(DateTime v, {String format = 'dd-MM-yyyy – hh:mm a'}) {
    try {
      return DateFormat(format).format(v).toString();
    } catch (e) {
      return '';
    }
  }

  static String formatBy(DateTime v, MyDateTimeFormatTypes t) {
    try {
      return DateFormat(castTypesFormat(t)).format(v).toString();
    } catch (e) {
      return '';
    }
  }

  static String formatTimeOfDayBy(TimeOfDay v, MyDateTimeFormatTypes t) {
    try {
      return DateFormat(castTypesFormat(t))
          .format(DateTime.utc(2019, 1, 1, v.hour, v.minute))
          .toString();
    } catch (e) {
      return '';
    }
  }

  static String formatByFromString(String v, MyDateTimeFormatTypes t) {
    try {
      return DateFormat(castTypesFormat(t)).format(DateTime.parse(v));
    } catch (e) {
      return '';
    }
  }

  static String formatAndShort(DateTime v,
      {String format = 'dd-MM-yyyy – hh:mm a'}) {
    try {
      if (v.isBefore(DateTime.now())) {
        return DateFormat(format).format(v).toString();
      } else {
        return formatBy(v, MyDateTimeFormatTypes.hhmma);
      }
    } catch (e) {
      return '';
    }
  }

  static String formatDateAndShort(DateTime v, {String format = 'dd-MM-yyyy'}) {
    try {
      if (v.year == DateTime.now().year &&
          v.month == DateTime.now().month &&
          v.day == DateTime.now().day) {
        return '';
      } else {
        return formatBy(v, MyDateTimeFormatTypes.ddMMyyyy);
      }
    } catch (e) {
      return '';
    }
  }

  static String formatAndShortBy(DateTime v, MyDateTimeFormatTypes t) {
    try {
      if (v.year == DateTime.now().year &&
          v.month == DateTime.now().month &&
          v.day == DateTime.now().day) {
        return formatBy(v, MyDateTimeFormatTypes.hhmma);
      } else {
        return DateFormat(castTypesFormat(t)).format(v).toString();
      }
    } catch (e) {
      return '';
    }
  }

  static String formatAndShortByFromString(String v, MyDateTimeFormatTypes t) {
    try {
      DateTime v1 = DateTime.parse(v);

      if (v1.year == DateTime.now().year &&
          v1.month == DateTime.now().month &&
          v1.day == DateTime.now().day) {
        return formatBy(v1, MyDateTimeFormatTypes.hhmma);
      } else {
        return DateFormat(castTypesFormat(t)).format(v1).toString();
      }
    } catch (e) {
      return '';
    }
  }

  static String getStringFromNow(String format, {int extraDays = 0}) {
    try {
      return DateFormat(format)
          .format(DateTime.now().add(Duration(days: extraDays)));
    } catch (e) {
      return e.toString();
    }
  }

  static String shortMMYYYY(String v) {
    try {
      if (v.substring(3) == DateTime.now().year.toString())
        return v.substring(0, 2);
    } catch (e) {
      return v;
    }
    return v;
  }

  static DateTime toMe(DateTime v) {
    return v == null ? DateTime.now() : v;
  }

  static DateTime getLess(DateTime v, DateTime v1) {
    return v.isBefore(v1) ? v : v1;
  }

  static DateTime getBiggest(DateTime v, DateTime v1) {
    return v.isAfter(v1) ? v : v1;
  }

  static int castDateNowToInt({int addNumber = 0}) {
    try {
      DateTime v = DateTime.now();
      return v.year + v.month + v.day + addNumber;
    } catch (e) {}
    return 0;
  }

  static int castDateToInt(DateTime v, {int addNumber = 0}) {
    try {
      return v.year + v.month + v.day + addNumber;
    } catch (e) {}
    return 0;
  }

  static int castDateToYearMonthNumber(DateTime v) {
    try {
      return int.parse(format(v, format: 'yyyyMM'));
    } catch (e) {}
    return 0;
  }
}
