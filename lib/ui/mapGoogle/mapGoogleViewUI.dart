import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myLocation.dart' as myLocation;

CameraPosition _currentCameraPosition;

class UI extends StatefulWidget {
  final String _name;
  final String _phones;

  UI(this._name, this._phones, GeoPoint mapLocation) {
    _currentCameraPosition = CameraPosition(
        target: LatLng(mapLocation.latitude, mapLocation.longitude),
        zoom: 14.0);
  }

  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  GoogleMapController _c;
  LatLng _myLocation;

  @override
  void initState() {
    initStateMe();
    super.initState();
  }

  void initStateMe() async {
    _myLocation = await myLocation.getByLatLngGoogle();
    _c.addMarker(MarkerOptions(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _myLocation,
        infoWindowText: InfoWindowText('Me', '')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GoogleMap(
        onMapCreated: (GoogleMapController c) {
          setState(() {
            _c = c;
            _c.addMarker(MarkerOptions(
                position: _currentCameraPosition.target,
                infoWindowText: InfoWindowText(widget._name, widget._phones)));
          });
        },
        options: GoogleMapOptions(
          cameraPosition: _currentCameraPosition,
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.viewLocation)),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.center_focus_strong),
      onPressed: _reviewLocation,
      backgroundColor: myColor.color1,
    );
  }

  void _reviewLocation() {
    _c.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
}
