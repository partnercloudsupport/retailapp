import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

Future<LatLng> getByLatLng() async {
  Map<String, double> location = await Location().getLocation();
  return LatLng(location['latitude'], location['longitude']);
}

Future<GeoPoint> getByGeoPoint() async {
  Map<String, double> location = await Location().getLocation();
  return GeoPoint(location['latitude'], location['longitude']);
}
