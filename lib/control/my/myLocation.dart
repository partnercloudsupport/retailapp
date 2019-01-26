import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myLanguage.dart';

class MyLocation {
  static Future<bool> checkAll(
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    Geolocator geoLocator = Geolocator();

    GeolocationStatus status =
        await geoLocator.checkGeolocationPermissionStatus();

    bool v = (status == GeolocationStatus.granted);

    if (status == GeolocationStatus.denied)
      MySnackBar.show4(scaffoldKey,
          MyLanguage.text(myLanguageItem.weNeedPermissionForYourLocation));
    else if (status == GeolocationStatus.disabled)
      MySnackBar.show4(scaffoldKey,
          MyLanguage.text(myLanguageItem.weNeedYouToEnableYourLocation));
    else if (status == GeolocationStatus.restricted)
      MySnackBar.show4(scaffoldKey, status.toString());
    else if (status == GeolocationStatus.unknown)
      MySnackBar.show4(scaffoldKey, status.toString());

    return v;
  }

  static Future<latlong.LatLng> getByLatLng() async {
    var getLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return latlong.LatLng(getLocation.latitude, getLocation.longitude);
  }

  static Future<LatLng> getByLatLngGoogle() async {
    var getLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(getLocation.latitude, getLocation.longitude);
  }

  static Future<GeoPoint> getByGeoPoint() async {
    var getLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(getLocation.latitude, getLocation.longitude);
  }
}
