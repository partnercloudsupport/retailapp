import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/mapBox/controlMapBox.dart' as controlMapBox;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:location/location.dart';

LatLng _currentPoint;
void Function(LatLng) _save;

class UI extends StatefulWidget {
  UI(void Function(LatLng) save, LatLng currentPoint) {
    _save = save;
    _currentPoint = currentPoint;
  }
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  LatLng _myLocation;

  @override
  void initState() {
    super.initState();
    initMyLocation();
  }

  void initMyLocation() async {
    Map<String, double> location = await Location().getLocation();
    _myLocation = LatLng(location['latitude'], location['longitude']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FlutterMap(
        options: MapOptions(
          onTap: (LatLng v) => _setNewLocation(v),
          center: _currentPoint,
          zoom: 14.0,
        ),
        layers: [
          controlMapBox.tileLayerOptions(),
          _buildMarkerLayerOptions(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.TextIndex.detectLocation)),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(
          Icons.save,
          color: myColor.master2,
        ),
        onPressed: _saveLocation,
      )
    ];
  }

  LayerOptions _buildMarkerLayerOptions() {
    return MarkerLayerOptions(
      markers: [_buildCurrentMarker()],
    );
  }

  Marker _buildCurrentMarker() {
    return Marker(
      width: 100.0,
      height: 100.0,
      point: _currentPoint,
      builder: (ctx) => Icon(
            Icons.location_on,
            color: myColor.master,
          ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.my_location),
      onPressed: _setMyLocation,
    );
  }

  void _setNewLocation(LatLng v) {
    setState(() {
      _currentPoint = v;
    });
  }

  void _setMyLocation() {
    setState(() {
      _currentPoint = _myLocation;
    });
  }

  void _saveLocation() {
    _save(_currentPoint);
    Navigator.pop(context);
  }
}
