import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;

void show(GlobalKey<ScaffoldState> scaffoldKey, String text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      text,
      style: myStyle.textEdit(),
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: '...',
      onPressed: () => scaffoldKey.currentState
          .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss),
    ),
  ));
}
