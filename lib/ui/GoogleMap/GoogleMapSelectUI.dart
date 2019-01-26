import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


CameraPosition _currentCameraPosition;
void Function(LatLng) _save;

class GoogleMapSelectUI extends StatefulWidget {
  final String _name;
  final String _phones;
  GoogleMapSelectUI(void Function(LatLng) save, this._name, this._phones,
      LatLng currentPoint) {
    _currentCameraPosition = CameraPosition(
        target: LatLng(currentPoint.latitude, currentPoint.longitude),
        zoom: 18.0);
    _save = save;
  }

  _GoogleMapSelectUIState createState() => _GoogleMapSelectUIState();
}

class _GoogleMapSelectUIState extends State<GoogleMapSelectUI> {
  GoogleMapController _c;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GoogleMap(
        onMapCreated: (GoogleMapController c) {
          setState(() {
            _c = c;
            _c.addMarker(MarkerOptions(
                draggable: true,
                position: _currentCameraPosition.target,
                infoWindowText: InfoWindowText(widget._name, widget._phones)));
          });
        },
        options: GoogleMapOptions(
            trackCameraPosition: true, cameraPosition: _currentCameraPosition),
      ),
      floatingActionButton: _buildFloatingActionButtonReviewLocation(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.viewLocation)),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(
          Icons.save,
          color: MyColor.color2,
        ),
        onPressed: _saveLocation,
      )
    ];
  }

  Widget _buildFloatingActionButtonReviewLocation() {
    return FloatingActionButton(
      child: Icon(Icons.center_focus_strong),
      onPressed: _reviewLocation,
      backgroundColor: MyColor.color1,
    );
  }

  void _reviewLocation() {
    _c.clearMarkers();

    _c.addMarker(MarkerOptions(
        draggable: true,
        position: _c.cameraPosition.target,
        infoWindowText: InfoWindowText(widget._name, widget._phones)));
  }

  void _saveLocation() {
    _save(_c.markers.first.options.position);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
}
