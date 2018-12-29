import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;

void showInHomePage(String text) {
  homePageUI.scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.style20(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: r'>',
      onPressed: () => homePageUI.scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}

void show(GlobalKey<ScaffoldState> scaffoldKey, String text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.style20(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: '>',
      onPressed: () => scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}
