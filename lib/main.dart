import 'package:flutter/material.dart';

import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/customer/customerNewUI.dart' as customerNewUI;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/ui/user/userLoginUI.dart' as userLoginUI;
import 'package:retailapp/control/my/mySharedPreferences.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/request/requestListUI.dart' as requestListUI;

void main() {
  //Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
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
    MyLanguage.setLanguage(await MySharedPreferences.getLanguageApp());
    userLoginUI.userName = await MySharedPreferences.getUserName();
    requestListUI.filterEmployee =
        await MySharedPreferences.getRequestFilterEmployee();

    bool myAccountIsVaild = await controlUser.signInByAuto(
        await MySharedPreferences.getUserName(),
        await MySharedPreferences.getUserPassword());

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
          ThemeData(primarySwatch: Colors.blue, primaryColor: MyColor.color1),
      routes: <String, WidgetBuilder>{
        '/customerNewUI': (BuildContext context) => customerNewUI.UI(),
      },
    );
  }
}
