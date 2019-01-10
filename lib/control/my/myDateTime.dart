import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Types { hhmma, kkmm, ddMMyyyy, ddMMyyyykk, ddMMyyyykkmm, ddMMyyyyhhmma }

String _castTypesFormat(Types t) {
  switch (t) {
    case Types.hhmma:
      return 'hh:mm a';
      break;
    case Types.kkmm:
      return 'kk:mm';
      break;
    case Types.ddMMyyyy:
      return 'dd-MM-yyyy';
      break;
    case Types.ddMMyyyykk:
      return 'dd-MM-yyyy – kk';
      break;
    case Types.ddMMyyyykkmm:
      return 'dd-MM-yyyy – kk:mm';
      break;
    case Types.ddMMyyyyhhmma:
      return 'dd-MM-yyyy – hh:mm a';
      break;
    default:
      {
        return 'dd-MM-yyyy – hh:mm a';
      }
      break;
  }
}

String format(DateTime v, {String format = 'dd-MM-yyyy – hh:mm a'}) {
  try {
    return DateFormat(format).format(v).toString();
  } catch (e) {
    return '';
  }
}

String formatBy(DateTime v, Types t) {
  try {
    return DateFormat(_castTypesFormat(t)).format(v).toString();
  } catch (e) {
    return '';
  }
}

String formatTimeOfDayBy(TimeOfDay v, Types t) {
  try {
    return DateFormat(_castTypesFormat(t))
        .format(DateTime.utc(2019, 1, 1, v.hour, v.minute))
        .toString();
  } catch (e) {
    return '';
  }
}

String formatByFromString(String v, Types t) {
  try {
    return DateFormat(_castTypesFormat(t)).format(DateTime.parse(v));
  } catch (e) {
    return '';
  }
}

String formatAndShort(DateTime v, {String format = 'dd-MM-yyyy – hh:mm a'}) {
  try {
    if (v.isBefore(DateTime.now())) {
      return DateFormat(format).format(v).toString();
    } else {
      return formatBy(v, Types.hhmma);
    }
  } catch (e) {
    return '';
  }
}

String formatDateAndShort(DateTime v, {String format = 'dd-MM-yyyy'}) {
  try {
    if (v.year == DateTime.now().year &&
        v.month == DateTime.now().month &&
        v.day == DateTime.now().day) {
      return '';
    } else {
      return formatBy(v, Types.ddMMyyyy);
    }
  } catch (e) {
    return '';
  }
}

String formatAndShortBy(DateTime v, Types t) {
  try {
    if (v.year == DateTime.now().year &&
        v.month == DateTime.now().month &&
        v.day == DateTime.now().day) {
      return formatBy(v, Types.hhmma);
    } else {
      return DateFormat(_castTypesFormat(t)).format(v).toString();
    }
  } catch (e) {
    return '';
  }
}

String formatAndShortByFromString(String v, Types t) {
  try {
    DateTime v1 = DateTime.parse(v);

    if (v1.year == DateTime.now().year &&
        v1.month == DateTime.now().month &&
        v1.day == DateTime.now().day) {
      return formatBy(v1, Types.hhmma);
    } else {
      return DateFormat(_castTypesFormat(t)).format(v1).toString();
    }
  } catch (e) {
    return '';
  }
}

String getStringFromNow(String format, {int extraDays = 0}) {
  try {
    return DateFormat(format)
        .format(DateTime.now().add(Duration(days: extraDays)));
  } catch (e) {
    return e.toString();
  }
}

DateTime toMe(DateTime v) {
  return v == null ? DateTime.now() : v;
}

DateTime getLess(DateTime v, DateTime v1) {
  return v.isBefore(v1) ? v : v1;
}

DateTime getBiggest(DateTime v, DateTime v1) {
  return v.isAfter(v1) ? v : v1;
}
