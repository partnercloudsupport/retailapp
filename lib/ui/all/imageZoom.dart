import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class UI extends StatelessWidget {
  final String _pathImage;
  UI(this._pathImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: CachedNetworkImageProvider(_pathImage),
      ),
    );
  }
}
