import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myString.dart' as myString;
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myTypes.dart' as myTypes;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  String _userName = 'sa@sa.com';
  String _userPassword = '12345678';
  myTypes.Login _typeLogin = myTypes.Login.login;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                _buildRaisedButtonLoginOrCreate(),
                _buildFlatButtonLoginOrCreate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormFieldName() {
    return TextFormField(
      initialValue: 'sa@sa.com',
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.yourName)),
      style: myStyle.textEdit(),
      validator: (v) => v.isEmpty
          ? myLanguage.text(myLanguage.TextIndex.youMustInsertYourName)
          : myString.isEmail(v) == false
              ? myLanguage.text(myLanguage.TextIndex.emailIsInvalid)
              : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => _userName = v.trim(),
    );
  }

  Widget _buildTextFormFieldPass() {
    return TextFormField(
      initialValue: '12345678',
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.yourPassword)),
      validator: (v) {
        if (v.isEmpty)
          return myLanguage
              .text(myLanguage.TextIndex.youMustInsertYourPassword);
        else if (v.length < 8) {
          return myLanguage
              .text(myLanguage.TextIndex.passwordMustBe8CharactersOrMore);
        }
        return null;
      },
      onSaved: (v) => _userPassword = v.trim(),
      obscureText: true,
      style: myStyle.textEdit(),
    );
  }

  Widget _buildRaisedButtonLoginOrCreate() {
    return RaisedButton(
      child: Text(
        _typeLogin == myTypes.Login.login
            ? myLanguage.text(myLanguage.TextIndex.login)
            : myLanguage.text(myLanguage.TextIndex.createAnAccount),
        style: myStyle.button(),
      ),
      onPressed: _save,
    );
  }

  Widget _buildFlatButtonLoginOrCreate() {
    return FlatButton(
      child: Text(
        _typeLogin == myTypes.Login.create
            ? myLanguage.text(myLanguage.TextIndex.login)
            : myLanguage.text(myLanguage.TextIndex.createAnAccount),
        style: myStyle.button(),
      ),
      onPressed: _changeType,
    );
  }

  void _changeType() {
    setState(() {
      _typeLogin = _typeLogin == myTypes.Login.login
          ? myTypes.Login.create
          : myTypes.Login.login;
    });
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
        if (_typeLogin == myTypes.Login.login) {
          await controlUser.signIn(_userName, _userPassword, _scaffoldKey);

          _formKey.currentState.reset();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePageUI.UI(4)),
              ModalRoute.withName(''));
        } else if (_typeLogin == myTypes.Login.create) {
          await controlUser.create(_userName, _userPassword, _scaffoldKey);

          _changeType();
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
