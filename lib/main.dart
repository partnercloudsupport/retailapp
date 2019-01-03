import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/customer/customerNewUI.dart' as customerNewUI;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/ui/user/userLoginUI.dart' as userLoginUI;
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/request/requestListUI.dart' as requestListUI;

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

void main() {
  runApp(UI());
}

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  bool _myLanguageIsLoaded = false;
  bool _myAccountIsVaild = false;

  _UIState() {
    _initState();
  }

  void _initState() async {
    myLanguage.setLanguage(await mySharedPreferences.getLanguageApp());
    userLoginUI.userName = await mySharedPreferences.getUserName();
    requestListUI.filterByEmployee =
        await mySharedPreferences.getRequestFilterEmployee();

    bool myAccountIsVaild = await controlUser.signInByAuto(
        scaffoldKey,
        await mySharedPreferences.getUserName(),
        await mySharedPreferences.getUserPassword());

    setState(() {
      _myLanguageIsLoaded = true;
      _myAccountIsVaild = myAccountIsVaild;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Security',
      home: _myLanguageIsLoaded == false
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _myAccountIsVaild ? homePageUI.UI(4) : userLoginUI.UI(),
      theme:
          ThemeData(primarySwatch: Colors.blue, primaryColor: myColor.color1),
      routes: <String, WidgetBuilder>{
        '/customerNewUI': (BuildContext context) => customerNewUI.UI(),
      },
    );
  }
}
