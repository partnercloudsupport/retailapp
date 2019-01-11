import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/request/controlRequestImage.dart'
    as controlRequestImage;
import 'package:retailapp/ui//all/imageViewAsset.dart' as imageViewAsset;

class UI extends StatefulWidget {
  final double _requestID;
  UI(this._requestID);
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final formKey = GlobalKey<FormState>();
  String _note = '';
  final FocusNode _focusNode1 = new FocusNode();
  List<Asset> _images = List<Asset>();

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
    return _images.length > 0
        ? GridView.count(
            crossAxisCount: 3,
            children: List.generate(_images.length, (index) {
              return imageViewAsset.UI(_images[index]);
            }),
          )
        : Container(
            child: new Icon(
              Icons.image,
              size: 250.0,
              color: myColor.color1,
            ),
          );
  }

  Widget _buildLoadImage() {
    return RaisedButton.icon(
        onPressed: _loadAssets,
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

  // void _loadImage() async {
  //   List resultList;
  //   try {
  //     resultList = await FlutterMultipleImagePicker.pickMultiImages(5, false);
  //     setState(() {
  //       _images = resultList;
  //     });

  //     FocusScopeNode().requestFocus(_focusNode1);
  //   } catch (e) {}
  // }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    } catch (e) {}

    if (!mounted || resultList == null || resultList.length == 0) return;

    setState(() {
      _images = resultList;
    });
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
        await controlRequestImage.save2(widget._requestID, _note, i);
      });
      Navigator.pop(context);
    }
  }
}
