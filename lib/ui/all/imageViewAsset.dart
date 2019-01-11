import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';

class UI extends StatefulWidget {
  final Asset _asset;
  UI(this._asset);

  @override
  State<StatefulWidget> createState() => _UI(this._asset);
}

class _UI extends State<UI> {
  Asset _asset;
  _UI(this._asset);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await this._asset.requestThumbnail(300, 300, quality: 50);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.thumbData) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Image.memory(
          this._asset.thumbData.buffer.asUint8List(),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      );
    }

    return SizedBox();
  }
}
