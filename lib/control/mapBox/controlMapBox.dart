import 'package:flutter_map/flutter_map.dart';

LayerOptions tileLayerOptions() {
  return TileLayerOptions(
    urlTemplate: "https://api.tiles.mapbox.com/v4/"
        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
    additionalOptions: {
      'accessToken':
          'pk.eyJ1Ijoic2FtZXJicmVlcyIsImEiOiJjam95ZWZnOHAyYjdzM3ZwYXR1am05M2VpIn0.jclfeVUmWniV5y7gY6XWkw',
      'id': 'mapbox.streets',
    },
  );
}
