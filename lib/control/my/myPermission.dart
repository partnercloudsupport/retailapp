import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

enum MyPermissionGroup {
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

PermissionGroup toPermissionGroup(MyPermissionGroup i) {
  switch (i) {
    case MyPermissionGroup.unknown:
      return PermissionGroup.unknown;
      break;
    case MyPermissionGroup.calendar:
      return PermissionGroup.calendar;
      break;
    case MyPermissionGroup.camera:
      return PermissionGroup.camera;
      break;
    case MyPermissionGroup.contacts:
      return PermissionGroup.contacts;
      break;
    case MyPermissionGroup.location:
      return PermissionGroup.location;
      break;
    case MyPermissionGroup.microphone:
      return PermissionGroup.microphone;
      break;
    case MyPermissionGroup.phone:
      return PermissionGroup.phone;
      break;
    case MyPermissionGroup.photos:
      return PermissionGroup.photos;
      break;
    case MyPermissionGroup.reminders:
      return PermissionGroup.reminders;
      break;
    case MyPermissionGroup.sensors:
      return PermissionGroup.sensors;
      break;
    case MyPermissionGroup.sms:
      return PermissionGroup.sms;
      break;
    case MyPermissionGroup.storage:
      return PermissionGroup.storage;
      break;
    case MyPermissionGroup.speech:
      return PermissionGroup.speech;
      break;
    case MyPermissionGroup.locationAlways:
      return PermissionGroup.locationAlways;
      break;
    case MyPermissionGroup.locationWhenInUse:
      return PermissionGroup.locationWhenInUse;
      break;
    case MyPermissionGroup.mediaLibrary:
      return PermissionGroup.mediaLibrary;
      break;
    default:
      return PermissionGroup.unknown;
  }
}

String permissionGroupToString(MyPermissionGroup i) {
  switch (i) {
    case MyPermissionGroup.unknown:
      return 'unknown';
      break;
    case MyPermissionGroup.calendar:
      return 'calendar';
      break;
    case MyPermissionGroup.camera:
      return 'camera';
      break;
    case MyPermissionGroup.contacts:
      return 'contacts';
      break;
    case MyPermissionGroup.location:
      return 'location';
      break;
    case MyPermissionGroup.microphone:
      return 'microphone';
      break;
    case MyPermissionGroup.phone:
      return 'phone';
      break;
    case MyPermissionGroup.photos:
      return 'photos';
      break;
    case MyPermissionGroup.reminders:
      return 'reminders';
      break;
    case MyPermissionGroup.sensors:
      return 'sensors';
      break;
    case MyPermissionGroup.sms:
      return 'sms';
      break;
    case MyPermissionGroup.storage:
      return 'storage';
      break;
    case MyPermissionGroup.speech:
      return 'speech';
      break;
    case MyPermissionGroup.locationAlways:
      return 'locationAlways';
      break;
    case MyPermissionGroup.locationWhenInUse:
      return 'locationWhenInUse';
      break;
    case MyPermissionGroup.mediaLibrary:
      return 'mediaLibrary';
      break;
    default:
      return 'unknown';
  }
}

Future<bool> openAppSetting() async {
  return await PermissionHandler().openAppSettings();
}

Future<bool> checkPermission(
    GlobalKey<ScaffoldState> scaffoldKey, MyPermissionGroup p) async {
  PermissionStatus status =
      await PermissionHandler().checkPermissionStatus(toPermissionGroup(p));
  return showMessage(scaffoldKey, status, p);
}

Future<bool> checkPermissionThenrequest(
    GlobalKey<ScaffoldState> scaffoldKey, MyPermissionGroup p) async {
  PermissionStatus status =
      await PermissionHandler().checkPermissionStatus(toPermissionGroup(p));

  if (status == PermissionStatus.denied)
    return requestPermission(scaffoldKey, p);

  if (status == PermissionStatus.granted) return true;

  return showMessage(scaffoldKey, status, p);
}

Future<bool> requestPermission(
    GlobalKey<ScaffoldState> scaffoldKey, MyPermissionGroup p) async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([toPermissionGroup(p)]);
  return showMessage(scaffoldKey, permissions.values.first, p);
}

bool showMessage(GlobalKey<ScaffoldState> scaffoldKey, PermissionStatus status,
    MyPermissionGroup p) {
  bool v = (status == PermissionStatus.granted);

  if (v == true) return true;

  if (status == PermissionStatus.denied)
    mySnackBar.show4(
        scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedPermissionForYour) +
            ': ' +
            permissionGroupToString(p));
  else if (status == PermissionStatus.disabled)
    mySnackBar.show4(
        scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedYouToEnableYour) +
            ': ' +
            permissionGroupToString(p));
  else if (status == PermissionStatus.restricted)
    mySnackBar.show4(scaffoldKey, 'restricted: ' + permissionGroupToString(p));
  else if (status == PermissionStatus.unknown)
    mySnackBar.show4(scaffoldKey, 'unknown: ' + permissionGroupToString(p));

  return v;
}
