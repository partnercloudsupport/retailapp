import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/control/my/mySharedPreferences.dart';

String userName = '';

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        key: scaffoldKey,
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
      initialValue: userName,
      decoration:
          InputDecoration(labelText: MyLanguage.text(myLanguageItem.yourName)),
      style: MyStyle.style20Color1(),
      validator: (v) => v.isEmpty
          ? MyLanguage.text(myLanguageItem.youMustInsertYourName)
          : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => userName = v.trim(),
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
          scaffoldKey, MyLanguage.text(myLanguageItem.theDataIsIncorrect));
      return false;
    }
  }

  void _save() async {
    if (_validatorSave()) {
      try {
        if (await controlUser.signInByEmail(
                scaffoldKey, 'samerbrees@gmail.com', '12345678') &&
            await controlUser.signIn(scaffoldKey, userName, _userPassword)) {
          await MySharedPreferences.setUserName(userName);
          await MySharedPreferences.setUserPassword(_userPassword);
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
