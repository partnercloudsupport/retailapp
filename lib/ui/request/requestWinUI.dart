import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;

import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myDouble.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myRegExp.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/request/controlRequestImage.dart'
    as controlRequestImage;
import 'package:retailapp/ui/all/selectWithFilterUI.dart';
import 'package:retailapp/ui//all/imageViewAssetUI.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class RequestWinUI extends StatefulWidget {
  final DocumentSnapshot dr;
  RequestWinUI(this.dr);
  _RequestWinUIState createState() => _RequestWinUIState();
}

class _RequestWinUIState extends State<RequestWinUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _context;
  final _formKey = GlobalKey<FormState>();
  String _paidByEmployee = '';
  double _amount = 0;
  String _deleteNote = '';
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
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
    _context = context;
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        key: _scaffoldKey,
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
      MyLanguage.text(myLanguageItem.requestCompleted),
      style: MyStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildEmployee(),
              _buildAmount(),
              _buildDeleteNote(),
              Container(
                child: _buildImageList(),
                height: 250,
              ),
              _buildLoadImage(),
              _buildIsPrivate(),
            ],
          )),
    );
  }

  Widget _buildEmployee() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: MyColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              MyLanguage.text(myLanguageItem.chooseAnEmployee),
              style: MyStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_paidByEmployee, style: MyStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: _openChooseEmployee,
    );
  }

  Widget _buildAmount() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(),
      inputFormatters: [
        WhitelistingTextInputFormatter(MyRegExp.number1To9999999),
      ],
      textInputAction: TextInputAction.next,
      style: MyStyle.style15Color1(),
      decoration: InputDecoration(
          prefix: Text(r'$ ', style: MyStyle.style14Color1()),
          suffix: Text(
            'USD',
            style: MyStyle.style14Color1(),
          ),
          labelText: MyLanguage.text(myLanguageItem.amount)),
      onSaved: (String v) => _amount = MyDouble.toMe(v),
      focusNode: _focusNode1,
      onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_focusNode2),
    );
  }

  Widget _buildDeleteNote() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: 3,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.note)),
      onSaved: (String v) => _deleteNote = v,
      focusNode: _focusNode2,
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

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectWithFilterUI(
                  controlEmployee.getShowInSchedule(),
                  _chooseEmployee,
                  MyLanguage.text(myLanguageItem.chooseAnEmployee),
                  autofocus: false,
                )));
  }

  void _chooseEmployee(String v) {
    setState(() {
      _paidByEmployee = v;
    });
    FocusScope.of(context).requestFocus(_focusNode1);
  }

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
//await controlRequest.addSomeColumn();

    if (_saveValidator() == true) {
      if (_imagesGallery.length > 0) {
        _imagesGallery.forEach((i) async {
          await controlRequestImage.saveByAsset(
              double.parse(widget.dr.documentID), _deleteNote, i, _isPrivate);
        });
      } else if (_imageCamera != null) {
        controlRequestImage.saveByFile(double.parse(widget.dr.documentID),
            _deleteNote, _imageCamera, _isPrivate);
      }
      if (await controlRequest.win(_scaffoldKey, widget.dr.documentID,
              _paidByEmployee, _amount, _deleteNote) ==
          true) {
        Navigator.pop(_context);
      }
    }
  }
}
