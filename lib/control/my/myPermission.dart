import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myLanguage.dart';

enum MyPermissionItem {
  unknown,
  calendar,
  camera,
  contacts,
  location,
  microphone,
  phone,
  photos,
  reminders,
  sensors,
  sms,
  storage,
  speech,
  locationAlways,
  locationWhenInUse,
  mediaLibrary
}

class MyPermission {
  static PermissionGroup toPermissionGroup(MyPermissionItem i) {
    switch (i) {
      case MyPermissionItem.unknown:
        return PermissionGroup.unknown;
        break;
      case MyPermissionItem.calendar:
        return PermissionGroup.calendar;
        break;
      case MyPermissionItem.camera:
        return PermissionGroup.camera;
        break;
      case MyPermissionItem.contacts:
        return PermissionGroup.contacts;
        break;
      case MyPermissionItem.location:
        return PermissionGroup.location;
        break;
      case MyPermissionItem.microphone:
        return PermissionGroup.microphone;
        break;
      case MyPermissionItem.phone:
        return PermissionGroup.phone;
        break;
      case MyPermissionItem.photos:
        return PermissionGroup.photos;
        break;
      case MyPermissionItem.reminders:
        return PermissionGroup.reminders;
        break;
      case MyPermissionItem.sensors:
        return PermissionGroup.sensors;
        break;
      case MyPermissionItem.sms:
        return PermissionGroup.sms;
        break;
      case MyPermissionItem.storage:
        return PermissionGroup.storage;
        break;
      case MyPermissionItem.speech:
        return PermissionGroup.speech;
        break;
      case MyPermissionItem.locationAlways:
        return PermissionGroup.locationAlways;
        break;
      case MyPermissionItem.locationWhenInUse:
        return PermissionGroup.locationWhenInUse;
        break;
      case MyPermissionItem.mediaLibrary:
        return PermissionGroup.mediaLibrary;
        break;
      default:
        return PermissionGroup.unknown;
    }
  }

  static String permissionGroupToString(MyPermissionItem i) {
    switch (i) {
      case MyPermissionItem.unknown:
        return 'unknown';
        break;
      case MyPermissionItem.calendar:
        return 'calendar';
        break;
      case MyPermissionItem.camera:
        return 'camera';
        break;
      case MyPermissionItem.contacts:
        return 'contacts';
        break;
      case MyPermissionItem.location:
        return 'location';
        break;
      case MyPermissionItem.microphone:
        return 'microphone';
        break;
      case MyPermissionItem.phone:
        return 'phone';
        break;
      case MyPermissionItem.photos:
        return 'photos';
        break;
      case MyPermissionItem.reminders:
        return 'reminders';
        break;
      case MyPermissionItem.sensors:
        return 'sensors';
        break;
      case MyPermissionItem.sms:
        return 'sms';
        break;
      case MyPermissionItem.storage:
        return 'storage';
        break;
      case MyPermissionItem.speech:
        return 'speech';
        break;
      case MyPermissionItem.locationAlways:
        return 'locationAlways';
        break;
      case MyPermissionItem.locationWhenInUse:
        return 'locationWhenInUse';
        break;
      case MyPermissionItem.mediaLibrary:
        return 'mediaLibrary';
        break;
      default:
        return 'unknown';
    }
  }

  static Future<bool> openAppSetting() async {
    return await PermissionHandler().openAppSettings();
  }

  static Future<bool> checkPermission(
      GlobalKey<ScaffoldState> scaffoldKey, MyPermissionItem p) async {
    PermissionStatus status =
        await PermissionHandler().checkPermissionStatus(toPermissionGroup(p));
    return showMessage(scaffoldKey, status, p);
  }

  static Future<bool> checkPermissionThenrequest(
      GlobalKey<ScaffoldState> scaffoldKey, MyPermissionItem p) async {
    PermissionStatus status =
        await PermissionHandler().checkPermissionStatus(toPermissionGroup(p));

    if (status == PermissionStatus.denied)
      return requestPermission(scaffoldKey, p);

    if (status == PermissionStatus.granted) return true;

    return showMessage(scaffoldKey, status, p);
  }

  static Future<bool> requestPermission(
      GlobalKey<ScaffoldState> scaffoldKey, MyPermissionItem p) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([toPermissionGroup(p)]);
    return showMessage(scaffoldKey, permissions.values.first, p);
  }

  static bool showMessage(GlobalKey<ScaffoldState> scaffoldKey,
      PermissionStatus status, MyPermissionItem p) {
    bool v = (status == PermissionStatus.granted);

    if (v == true) return true;

    if (status == PermissionStatus.denied)
      MySnackBar.show4(
          scaffoldKey,
          MyLanguage.text(myLanguageItem.weNeedPermissionForYour) +
              ': ' +
              permissionGroupToString(p));
    else if (status == PermissionStatus.disabled)
      MySnackBar.show4(
          scaffoldKey,
          MyLanguage.text(myLanguageItem.weNeedYouToEnableYour) +
              ': ' +
              permissionGroupToString(p));
    else if (status == PermissionStatus.restricted)
      MySnackBar.show4(
          scaffoldKey, 'restricted: ' + permissionGroupToString(p));
    else if (status == PermissionStatus.unknown)
      MySnackBar.show4(scaffoldKey, 'unknown: ' + permissionGroupToString(p));

    return v;
  }
}
