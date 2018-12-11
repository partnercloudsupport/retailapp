import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;

CameraPosition _currentCameraPosition;
void Function(LatLng) _save;

class UI extends StatefulWidget {
  final String _name;
  final String _phones;
  UI(void Function(LatLng) save, this._name, this._phones,
      LatLng currentPoint) {
    _currentCameraPosition = CameraPosition(
        target: LatLng(currentPoint.latitude, currentPoint.longitude),
        zoom: 18.0);
    _save = save;
  }

  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
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
      title: Text(myLanguage.text(myLanguage.item.viewLocation)),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(
          Icons.save,
          color: myColor.color2,
        ),
        onPressed: _saveLocation,
      )
    ];
  }

  Widget _buildFloatingActionButtonReviewLocation() {
    return FloatingActionButton(
      child: Icon(Icons.center_focus_strong),
      onPressed: _reviewLocation,
      backgroundColor: myColor.color1,
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
