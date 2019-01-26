import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/request/controlRequestImage.dart'
    as controlRequestImage;
import 'package:retailapp/ui//all/imageViewAssetUI.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class RequestImageNewUI extends StatefulWidget {
  final double _requestID;
  RequestImageNewUI(this._requestID);
  _RequestImageNewUIState createState() => _RequestImageNewUIState();
}

class _RequestImageNewUIState extends State<RequestImageNewUI> {
  final _formKey = GlobalKey<FormState>();
  String _note = '';
  final FocusNode _focusNode1 = new FocusNode();
  List<Asset> _imagesGallery = List<Asset>();
  File _imageCamera;
  bool _isPrivate = false;

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
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
        _imagesGallery.length > 0 || _imageCamera != null
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
      MyLanguage.text(myLanguageItem.newImage),
      style: MyStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: _buildImageList(),
              height: 300,
            ),
            _buildLoadImage(),
            _buildIsPrivate(),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return _imagesGallery.length > 0
        ? GridView.count(
            crossAxisCount: 3,
            children: List.generate(_imagesGallery.length, (index) {
              return ImageViewAssetUI(_imagesGallery[index]);
            }),
          )
        : _imageCamera != null
            ? Image.file(_imageCamera)
            : Container(
                child: new Icon(
                  Icons.image,
                  size: 250.0,
                  color: MyColor.color1,
                ),
              );
  }

  Widget _buildLoadImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton.icon(
            onPressed: _loadImagesGallery,
            icon: Icon(
              Icons.image,
              color: MyColor.color1,
            ),
            label: Text(
              MyLanguage.text(myLanguageItem.chooseImages),
              style: MyStyle.style16Color1(),
            )),
        RaisedButton.icon(
            onPressed: _takeImageCamera,
            icon: Icon(
              Icons.camera,
              color: MyColor.color1,
            ),
            label: Text(
              MyLanguage.text(myLanguageItem.captureAnImage),
              style: MyStyle.style16Color1(),
            ))
      ],
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.note)),
      onSaved: (String v) => _note = v,
      focusNode: _focusNode1,
    );
  }

  Widget _buildIsPrivate() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _isPrivate,
            onChanged: (v) => chooseIsPrivate(),
          ),
          Text(
            MyLanguage.text(myLanguageItem.itsMyPrivateImages),
            style: MyStyle.style16Color1(),
          )
        ],
      ),
      onTap: chooseIsPrivate,
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

  Future<void> _loadImagesGallery() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    } catch (e) {}

    if (!mounted || resultList == null || resultList.length == 0) return;

    setState(() {
      _imageCamera = null;
      _imagesGallery = resultList;
    });
  }

  Future _takeImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imagesGallery.clear();
        _imageCamera = image;
      });
    }
  }

  void chooseIsPrivate() {
    setState(() {
      _isPrivate = !_isPrivate;
    });
  }

  bool _saveValidator() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void _save() async {
    if (_saveValidator() == true) {
      if (_imagesGallery.length > 0) {
        _imagesGallery.forEach((i) async {
          await controlRequestImage.saveByAsset(
              widget._requestID, _note, i, _isPrivate);
        });
      } else if (_imageCamera != null) {
        controlRequestImage.saveByFile(
            widget._requestID, _note, _imageCamera, _isPrivate);
      }
      Navigator.pop(context);
    }
  }
}
