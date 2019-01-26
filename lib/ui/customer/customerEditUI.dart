import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/control/my/myString.dart';
import 'package:retailapp/ui/mapBox/mapBoxSelectUI.dart' as mapBoxSelectUI;

import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

DocumentSnapshot _dr;

class UI extends StatefulWidget {
  UI(DocumentSnapshot dr) {
    _dr = dr;
  }

  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  bool customerEditPhone = controlPermission.drNow.data['customerEditPhone'];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _context;
  String _name = _dr['name'];
  String _phones = _dr['phones'];
  String _address = _dr['address'];
  String _email = _dr['email'];
  String _note = _dr['note'];
  LatLng _mapLocation;
  GeoPoint _mapLocationBase = _dr['mapLocation'];
  final formKey = GlobalKey<FormState>();
  final FocusNode _focusNodePhones = new FocusNode();
  final FocusNode _focusNodeAddress = new FocusNode();
  final FocusNode _focusNodeEmail = new FocusNode();
  final FocusNode _focusNodeNote = new FocusNode();

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    initStateMe();
    _mapLocation =
        LatLng(_mapLocationBase.latitude, _mapLocationBase.longitude);
    super.initState();
  }

  void initStateMe() async {
    await controlPermission.getMe();
    setState(() {
      customerEditPhone = controlPermission.drNow.data['customerEditPhone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildForm(),
      ),
    );
  }

  _buildAppBar() {
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
      MyLanguage.text(myLanguageItem.editContact),
      style: MyStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              _buildName(),
              _buildPhones(),
              _buildAddress(),
              _buildEmail(),
              _buildNote(),
              _buildButtonMap()
            ],
          )),
    );
  }

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      textInputAction: TextInputAction.next,
      validator: (String v) => v.trim().isEmpty
          ? MyLanguage.text(myLanguageItem.youMustInsertText)
          : null,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.name)),
      onSaved: (String v) => _name = v,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusNodePhones);
      },
    );
  }

  Widget _buildPhones() {
    return customerEditPhone
        ? TextFormField(
            initialValue: _phones,
            focusNode: _focusNodePhones,
            textInputAction: TextInputAction.next,
            validator: (String v) => v.trim().isEmpty
                ? MyLanguage.text(myLanguageItem.youMustInsertText)
                : null,
            style: MyStyle.style15Color1(),
            decoration: InputDecoration(
                labelText: MyLanguage.text(myLanguageItem.phones)),
            onSaved: (String v) => _phones = v,
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(_focusNodeAddress);
            },
          )
        : SizedBox();
  }

  Widget _buildAddress() {
    return TextFormField(
      initialValue: _address,
      focusNode: _focusNodeAddress,
      textInputAction: TextInputAction.next,
      maxLines: 2,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.address)),
      onSaved: (String v) => _address = v,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusNodeEmail);
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      focusNode: _focusNodeEmail,
      textInputAction: TextInputAction.next,
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.email)),
      style: MyStyle.style15Color1(),
      validator: (v) => v.trim().isEmpty
          ? null
          : MyString.isEmail(v) == false
              ? MyLanguage.text(myLanguageItem.emailIsInvalid)
              : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => _email = v.trim(),
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusNodeNote);
      },
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      focusNode: _focusNodeNote,
      textInputAction: TextInputAction.done,
      maxLines: 2,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.note)),
      onSaved: (String v) => _note = v,
    );
  }

  Widget _buildButtonMap() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.edit_location,
              color: MyColor.color1,
            ),
            Text(
              MyLanguage.text(myLanguageItem.location),
              style: MyStyle.style18Color1(),
            )
          ],
        ),
        onTap: _openMap,
      ),
    );
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
      if (await controlCustomer.edit(
              scaffoldKey,
              _dr.documentID,
              _name,
              customerEditPhone ? _phones : _dr.data['phones'],
              _address,
              _email,
              _note,
              GeoPoint(_mapLocation.latitude, _mapLocation.longitude)) ==
          true) {
        Navigator.pop(_context);
      }
    }
  }

  void _openMap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                mapBoxSelectUI.UI(_saveLocation, _mapLocation)));
  }

  void _saveLocation(LatLng location) {
    setState(() {
      _mapLocation = location;
    });
  }
}
