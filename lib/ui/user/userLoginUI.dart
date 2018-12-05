import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;

String userName = '';

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            myLanguage.text(myLanguage.TextIndex.smartSecurity),
            style: myStyle.mainTitle2(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFormFieldName(),
                _buildTextFormFieldPass(),
                _buildRaisedButtonLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormFieldName() {
    return TextFormField(
      initialValue: userName,
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.yourName)),
      style: myStyle.textEdit(),
      validator: (v) => v.isEmpty
          ? myLanguage.text(myLanguage.TextIndex.youMustInsertYourName)
          : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => userName = v.trim(),
    );
  }

  Widget _buildTextFormFieldPass() {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.yourPassword)),
      validator: (v) {
        if (v.isEmpty)
          return myLanguage
              .text(myLanguage.TextIndex.youMustInsertYourPassword);

        return null;
      },
      onSaved: (v) => _userPassword = v.trim(),
      obscureText: true,
      style: myStyle.textEdit(),
    );
  }

  Widget _buildRaisedButtonLogin() {
    return RaisedButton(
      child: Text(
        myLanguage.text(myLanguage.TextIndex.login),
        style: myStyle.button(),
      ),
      onPressed: _save,
    );
  }

  bool _validatorSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      mySnackBar.show(_scaffoldKey,
          myLanguage.text(myLanguage.TextIndex.theDataIsIncorrect));
      return false;
    }
  }

  void _save() async {
    if (_validatorSave()) {
      try {
        if (await controlUser.signInByEmail(
                'samerbrees@gmail.com', '12345678', _scaffoldKey) &&
            await controlUser.signIn(userName, _userPassword, _scaffoldKey)) {
          await mySharedPreferences.setUserName(userName);
          await mySharedPreferences.setUserPassword(_userPassword);
          _formKey.currentState.reset();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePageUI.UI(4)),
              ModalRoute.withName(''));
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
