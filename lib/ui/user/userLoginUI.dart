import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/homePage/homePageUI.dart';
import 'package:retailapp/control/my/mySharedPreferences.dart';

class UserLoginUI extends StatefulWidget {
  _UserLoginUIState createState() => _UserLoginUIState();
}

class _UserLoginUIState extends State<UserLoginUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            MyLanguage.text(myLanguageItem.smartSecurity),
            style: MyStyle.style20Color2(),
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
      initialValue: _userName,
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.yourName)),
      style: MyStyle.style20Color1(),
      validator: (v) => v.isEmpty
          ? MyLanguage.text(myLanguageItem.youMustInsertYourName)
          : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => _userName = v.trim(),
    );
  }

  Widget _buildTextFormFieldPass() {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
          labelText: MyLanguage.text(myLanguageItem.yourPassword)),
      validator: (v) {
        if (v.isEmpty)
          return MyLanguage.text(myLanguageItem.youMustInsertYourPassword);

        return null;
      },
      onSaved: (v) => _userPassword = v.trim(),
      obscureText: true,
      style: MyStyle.style20Color1(),
    );
  }

  Widget _buildRaisedButtonLogin() {
    return RaisedButton(
      child: Text(
        MyLanguage.text(myLanguageItem.login),
        style: MyStyle.style18Color1(),
      ),
      onPressed: _save,
    );
  }

  bool _validatorSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      MySnackBar.show1(
          _scaffoldKey, MyLanguage.text(myLanguageItem.theDataIsIncorrect));
      return false;
    }
  }

  void _save() async {
    if (_validatorSave()) {
      try {
        if (await controlUser.signInByEmail(
                _scaffoldKey, 'samerbrees@gmail.com', '12345678') &&
            await controlUser.signIn(_scaffoldKey, _userName, _userPassword)) {
          await MySharedPreferences.setUserName(_userName);
          await MySharedPreferences.setUserPassword(_userPassword);
          _formKey.currentState.reset();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePageUI(4)),
              ModalRoute.withName(''));
        }
      } catch (e) {}
    }
  }
}
