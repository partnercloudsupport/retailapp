import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/control/my/myLanguage.dart';

class MySnackBar {
  static void showInHomePage1(String text) {
    homePageUI.homePageUIScaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: MyStyle.style20Color1(),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: MyLanguage.text(myLanguageItem.ok).toUpperCase(),
        textColor: MyColor.color1,
        onPressed: () => homePageUI.homePageUIScaffoldKey.currentState
            .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
      ),
    ));
  }

  static void show1(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: MyStyle.style20Color1(),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: MyLanguage.text(myLanguageItem.ok).toUpperCase(),
        textColor: MyColor.color1,
        onPressed: () => scaffoldKey.currentState
            .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
      ),
    ));
  }

  static void show4(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: MyStyle.style20Color4(),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: MyLanguage.text(myLanguageItem.ok).toUpperCase(),
        textColor: MyColor.color4,
        onPressed: () => scaffoldKey.currentState
            .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
      ),
    ));
  }
}
