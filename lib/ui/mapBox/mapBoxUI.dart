import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  Marker map = Marker(
    width: 100.0,
    height: 100.0,
    point: new LatLng(34.426992, 35.842292),
    builder: (ctx) => Icon(Icons.home),
  );

  void setmap(LatLng v) {
    setState(() {
      map = Marker(
        width: 100.0,
        height: 100.0,
        point: v,
        builder: (ctx) => Icon(
              Icons.location_on,
              color: Colors.green,
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () => {},
          )
        ],
      ),
      body: new FlutterMap(
        options: new MapOptions(
          onTap: (LatLng v) => setmap(v),
          onPositionChanged: (MapPosition v, bool v1) {},
          center: new LatLng(34.426232, 35.842242),
          zoom: 14.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoic2FtZXJicmVlcyIsImEiOiJjam95ZWZnOHAyYjdzM3ZwYXR1am05M2VpIn0.jclfeVUmWniV5y7gY6XWkw',
              'id': 'mapbox.streets',
            },
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 120.0,
                height: 120.0,
                point: new LatLng(34.426232, 35.842242),
                builder: (ctx) => InkWell(
                      child: Icon(Icons.person, color: Colors.blue),
                      onTap: () {
                        print('samer brees');
                      },
                    ),
              ),
              new Marker(
                width: 100.0,
                height: 100.0,
                point: new LatLng(34.426992, 35.842292),
                builder: (ctx) =>
                    InkWell(
                      child: Icon(Icons.person, color: Colors.blue),
                      onTap: () {
                        print('rustom yamak');
                      },
                    ),
              ),
              map
            ],
          ),
        ],
      ),
    );
  }
}
