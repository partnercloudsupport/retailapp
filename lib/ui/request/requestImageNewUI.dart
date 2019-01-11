import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailapp/asset_view.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:retailapp/control/request/controlRequestImage.dart'
    as controlRequestImage;

import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

class UI extends StatefulWidget {
  final double _requestID;
  UI(this._requestID);

  _UIState2 createState() => _UIState2();
}

class _UIState2 extends State<UI> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return AssetView(index, images[index]);
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    } on PlatformException catch (e) {
      error = e.message;
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            RaisedButton(
              child: Text("save"),
              onPressed: _save,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }

  void _save() async {
    images.forEach((i) async {
      await controlRequestImage.save2(widget._requestID, '', i);
    });
    Navigator.pop(context);
  }
}

class _UIState extends State<UI> {
  final formKey = GlobalKey<FormState>();
  String _note = '';
  final FocusNode _focusNode1 = new FocusNode();
  List _images;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildForm(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: _buildTitle(),
      actions: <Widget>[
        _images != null
            ? IconButton(
                icon: Icon(Icons.save),
                onPressed: _save,
              )
            : SizedBox()
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      myLanguage.text(myLanguage.item.newImage),
      style: myStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: _buildImageList(),
              height: 300,
            ),
            _buildLoadImage(),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return _images != null
        ? ListView.builder(
            itemBuilder: _buildImage,
            itemCount: _images.length,
          )
        : Container(
            child: new Icon(
              Icons.image,
              size: 250.0,
              color: myColor.color1,
            ),
          );
  }

  Widget _buildImage(BuildContext context, int i) {
    return ListTile(
      title: Container(
        child: Image.file(
          File(_images[i].toString()),
        ),
        height: 250,
      ),
    );
  }

  Widget _buildLoadImage() {
    return RaisedButton.icon(
        onPressed: _loadImage,
        icon: Icon(
          Icons.image,
          color: myColor.color1,
        ),
        label: Text(
          "Load Images",
          style: myStyle.style16Color1(),
        ));
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: myStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: myLanguage.text(myLanguage.item.note)),
      onSaved: (String v) => _note = v,
      focusNode: _focusNode1,
    );
  }

  void _loadImage() async {
    List resultList;
    try {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(5, false);
      setState(() {
        _images = resultList;
      });

      FocusScopeNode().requestFocus(_focusNode1);
    } catch (e) {}
  }

  bool _saveValidator() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void _save() async {
    if (_saveValidator() == true) {
      _images.forEach((i) async {
        print(i);
        // await controlRequestImage.save(widget._requestID, _note, i);
      });
      //  Navigator.pop(context);
    }
  }
}
