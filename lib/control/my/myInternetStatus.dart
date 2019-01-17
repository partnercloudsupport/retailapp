import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:retailapp/control/my/mySuperTooltip.dart' as mySuperTooltip;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

Future<ConnectivityResult> getStatusNow() async {
  return await Connectivity().checkConnectivity();
}

Future<bool> checkInternetWithTip(BuildContext context) async {
  var result = await Connectivity().checkConnectivity();

  if (result == ConnectivityResult.none)
    mySuperTooltip.show4(context,
        myLanguage.text(myLanguage.item.youAreNotConnectedToTheInternet));

  return (result != ConnectivityResult.none);
}
