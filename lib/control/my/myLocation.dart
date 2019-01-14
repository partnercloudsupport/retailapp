import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
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
    mySnackBar.show4(scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedPermissionForYourLocation));
  else if (status == GeolocationStatus.disabled)
    mySnackBar.show4(scaffoldKey,
        myLanguage.text(myLanguage.item.weNeedYouToEnableYourLocation));
  else if (status == GeolocationStatus.restricted)
    mySnackBar.show4(scaffoldKey, status.toString());
  else if (status == GeolocationStatus.unknown)
    mySnackBar.show4(scaffoldKey, status.toString());

  return v;
}

Future<latlong.LatLng> getByLatLng() async {
  var getLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return latlong.LatLng(getLocation.latitude, getLocation.longitude);
}

Future<LatLng> getByLatLngGoogle() async {
  var getLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return LatLng(getLocation.latitude, getLocation.longitude);
}

Future<GeoPoint> getByGeoPoint() async {
  var getLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return GeoPoint(getLocation.latitude, getLocation.longitude);
}
