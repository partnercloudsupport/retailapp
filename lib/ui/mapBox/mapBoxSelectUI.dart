import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:retailapp/control/mapBox/controlMapBox.dart' as controlMapBox;
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/MyLocation.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class MapBoxSelectUI extends StatefulWidget {
  final void Function(LatLng) _save;
  final LatLng _currentPoint;
  MapBoxSelectUI(this._save, this._currentPoint);

  _MapBoxSelectUIState createState() => _MapBoxSelectUIState(_currentPoint);
}

class _MapBoxSelectUIState extends State<MapBoxSelectUI> {
  LatLng _currentPoint;
  LatLng _myLocation;
  MapController _map;
  _MapBoxSelectUIState(this._currentPoint);
  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    _map = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FlutterMap(
        mapController: _map,
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
      title: Text(MyLanguage.text(myLanguageItem.detectLocation)),
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
            color: MyColor.color1,
          ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.my_location),
      onPressed: _setMyLocation,
      backgroundColor: MyColor.color1,
    );
  }

  void _setNewLocation(LatLng v) {
    setState(() {
      _currentPoint = v;
    });
  }

  void _setMyLocation() async {
    _myLocation = await MyLocation.getByLatLng();

    setState(() {
      _currentPoint = _myLocation;
      _map.move(_currentPoint, 14);
    });
  }

  void _saveLocation() {
    widget._save(_currentPoint);
    Navigator.pop(context);
  }
}
