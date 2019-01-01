import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

void showInHomePage1(String text) {
  homePageUI.scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.style20Color1(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: myLanguage.text(myLanguage.item.ok).toUpperCase(),
      textColor: myColor.color1,
      onPressed: () => homePageUI.scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}

void show1(GlobalKey<ScaffoldState> scaffoldKey, String text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.style20Color1(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: myLanguage.text(myLanguage.item.ok).toUpperCase(),
      textColor: myColor.color1,
      onPressed: () => scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}

void show4(GlobalKey<ScaffoldState> scaffoldKey, String text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.style20Color4(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: myLanguage.text(myLanguage.item.ok).toUpperCase(),
      textColor: myColor.color4,
      onPressed: () => scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}
