import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:retailapp/control/mapBox/controlMapBox.dart' as controlMapBox;
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';

LatLng _currentPoint;

class MapBoxViewUI extends StatefulWidget {
  final String _name;
  MapBoxViewUI(this._name, GeoPoint mapLocation) {
    _currentPoint = LatLng(mapLocation.latitude, mapLocation.longitude);
  }

  _MapBoxViewUIState createState() => _MapBoxViewUIState();
}

class _MapBoxViewUIState extends State<MapBoxViewUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FlutterMap(
        options: MapOptions(
          center: _currentPoint,
          zoom: 14.0,
        ),
        layers: [
          controlMapBox.tileLayerOptions(),
          _buildMarkerLayerOptions(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.viewLocation)),
    );
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
      builder: (ctx) => Column(
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: MyColor.color1,
              ),
              Text(
                widget._name,
                style: MyStyle.style16Color1(),
              )
            ],
          ),
    );
  }
}
