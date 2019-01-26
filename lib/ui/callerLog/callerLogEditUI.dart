import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/callerLog/controlCallerLog.dart'
    as controlCallerLog;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class CallerLogEditUI extends StatefulWidget {
  final DocumentSnapshot dr;
  CallerLogEditUI(this.dr);
  _CallerLogEditUIState createState() => _CallerLogEditUIState();
}

class _CallerLogEditUIState extends State<CallerLogEditUI> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _note = '';

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    _note = widget.dr['noteIs'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
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
      MyLanguage.text(myLanguageItem.editACallLog),
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
              _buildNote(),
            ],
          )),
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      maxLines: 4,
      style: MyStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.note)),
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
