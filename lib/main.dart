import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/customer/customerNewUI.dart' as customerNewUI;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
void main() {
  runApp(UI());
}

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  _UIState() {
    getLanguageApp();
  }
  String v;
  Future<Null> getLanguageApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    v = prefs.getString('languageApp') ?? 'en-US';

    myLanguage.setLanguage(v);

    setState(() {
      v = 'en-US';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Security',
     // home: v == null ? Text('') : uiLoginUser.UI(),
       home: homePageUI.UI(4), 
           theme:
          ThemeData(primarySwatch: Colors.blue, primaryColor: myColor.master),
      routes: <String, WidgetBuilder>{
        '/customerNewUI': (BuildContext context) => customerNewUI.UI(),
      },
    );
  }
}
