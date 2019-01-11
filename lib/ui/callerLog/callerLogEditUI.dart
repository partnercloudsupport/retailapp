import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/callerLog/controlCallerLog.dart'
    as controlCallerLog;

class UI extends StatefulWidget {
  final DocumentSnapshot dr;
  UI(this.dr);
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _note = '';

  @override
  void initState() {
    _note = widget.dr['noteIs'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        key: scaffoldKey,
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
      myLanguage.text(myLanguage.item.editACallLog),
      style: myStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              _buildNote(),
            ],
          )),
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      maxLines: 4,
      style: myStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: myLanguage.text(myLanguage.item.note)),
      onSaved: (String v) => _note = v,
    );
  }

  bool _saveValidator() {
    return true;
  }

  void _save() async {
    if (_saveValidator() == true) {
      formKey.currentState.save();
      if (await controlCallerLog.editNote(
              scaffoldKey, widget.dr.documentID, _note) ==
          true) {
        Navigator.pop(context);
      }
    }
  }
}
