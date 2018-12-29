import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

Future<bool> checkAll(
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  Geolocator geoLocator = Geolocator();

  GeolocationStatus status =
      await geoLocator.checkGeolocationPermissionStatus();

  bool v = (status == GeolocationStatus.granted);

  if (status == GeolocationStatus.denied)
    mySnackBar.show(scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedPermissionForYourLocation));
  else if (status == GeolocationStatus.disabled)
    mySnackBar.show(scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedYouToEnableYourLocation));
  else if (status == GeolocationStatus.restricted)
    mySnackBar.show(scaffoldKey, status.toString());
  else if (status == GeolocationStatus.unknown)
    mySnackBar.show(scaffoldKey, status.toString());

  return v;
}

Future<LatLng> getByLatLng() async {
  var getLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return LatLng(getLocation.latitude, getLocation.longitude);
}

Future<GeoPoint> getByGeoPoint() async {
  var getLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return GeoPoint(getLocation.latitude, getLocation.longitude);
}
