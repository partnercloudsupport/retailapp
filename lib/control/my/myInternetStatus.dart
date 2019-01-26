import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:retailapp/control/my/mySuperTooltip.dart';
import 'package:retailapp/control/my/myLanguage.dart';

class MyInternetStatus {
  static Future<ConnectivityResult> getStatusNow() async {
    return await Connectivity().checkConnectivity();
  }

  static Future<bool> checkInternetWithTip(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none)
      MySuperTooltip.show4(context,
          MyLanguage.text(myLanguageItem.youAreNotConnectedToTheInternet));

    return (result != ConnectivityResult.none);
  }
}
