import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
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
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _save,
        )
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
      child: ListView(
        children: <Widget>[
          Container(
            child: _buildImage(),
            height: 300,
          ),
          _buildLoadImage(),
          _buildNote(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return _images != null
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => new ListTile(
                  title: Container(
                    child: Image.file(
                      File(_images[index].toString()),
                    ),
                    height: 250,
                  ),
                ),
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

  Widget _buildLoadImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton.icon(
          onPressed: _loadImage,
          icon: Icon(
            Icons.image,
            color: myColor.color1,
          ),
          label: Text(
            "Load Images",
            style: myStyle.style16(),
          )),
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: myStyle.style15(),
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
      // if (await controlRequest.save(
      //         scaffoldKey,
      //         _customer,
      //         _employee,
      //         _requiredImplementation,
      //         _appointment,
      //         _targetPrice,
      //         3,
      //         _salseman,
      //         _typeIs) ==
      //     true) {
      //   Navigator.pop(_context);
      // }
    }
  }
}
