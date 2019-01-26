import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class ImageZoomUI extends StatelessWidget {
  final String _pathImage;
  ImageZoomUI(this._pathImage);

  @override
  Widget build(BuildContext context) {
    controlLiveVersion.checkupVersion(context);
    return Scaffold(
      body: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: CachedNetworkImageProvider(_pathImage),
      ),
    );
  }
}
