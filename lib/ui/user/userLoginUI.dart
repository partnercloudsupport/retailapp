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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            myLanguage.text(myLanguage.item.smartSecurity),
            style: myStyle.style20Color2(),
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
          InputDecoration(labelText: myLanguage.text(myLanguage.item.yourName)),
      style: myStyle.style20(),
      validator: (v) => v.isEmpty
          ? myLanguage.text(myLanguage.item.youMustInsertYourName)
          : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (v) => userName = v.trim(),
    );
  }

  Widget _buildTextFormFieldPass() {
    return TextFormField(
      initialValue: '',
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.item.yourPassword)),
      validator: (v) {
        if (v.isEmpty)
          return myLanguage.text(myLanguage.item.youMustInsertYourPassword);

        return null;
      },
      onSaved: (v) => _userPassword = v.trim(),
      obscureText: true,
      style: myStyle.style20(),
    );
  }

  Widget _buildRaisedButtonLogin() {
    return RaisedButton(
      child: Text(
        myLanguage.text(myLanguage.item.login),
        style: myStyle.style18(),
      ),
      onPressed: _save,
    );
  }

  bool _validatorSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      mySnackBar.show(
          scaffoldKey, myLanguage.text(myLanguage.item.theDataIsIncorrect));
      return false;
    }
  }

  void _save() async {
    if (_validatorSave()) {
      try {
        if (await controlUser.signInByEmail(
                scaffoldKey, 'samerbrees@gmail.com', '12345678') &&
            await controlUser.signIn(scaffoldKey, userName, _userPassword)) {
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
