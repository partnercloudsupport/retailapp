import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/CallerLog/controlCallerLog.dart' as controlRequest;
import 'package:retailapp/ui/callerLog/callerLogListUI.dart' as callerLogListUI;
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String text = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          myLanguage.text(myLanguage.TextIndex.smartSecurity),
          style: myStyle.textEdit2(),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Save',
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(key: formKey, child: _buildTextFormField()),
      ),
    );
  }

  Widget _buildTextFormField() {
    return TextFormField(
      maxLines: 5,
      validator: (String v) => v.trim().isEmpty
          ? myLanguage.text(myLanguage.TextIndex.youMustInsertText)
          : null,
      style: myStyle.textEdit(),
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.textToBeImplemented)),
      onSaved: (String v) => text = v,
    );
  }

  bool _validatorSave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      mySnackBar.show(scaffoldKey,
          myLanguage.text(myLanguage.TextIndex.theDataIsIncorrect));
      return false;
    }
  }

  void _save() async {
    if (_validatorSave() == true) {
      await controlRequest.save(scaffoldKey, '', '', text);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => callerLogListUI.UI()),
          ModalRoute.withName(''));
    }
  }

}
