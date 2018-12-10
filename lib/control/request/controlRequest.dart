import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/dataAccess/request/requestRow.dart' as requestRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'request';

Future<bool> save(
  GlobalKey<ScaffoldState> scaffoldKey,
  String customer,
  String employee,
  String requiredImplementation,
  DateTime appointment,
  double targetPrice,
  int stageIs,
  String salseman,
  String typeIs,
) async {
  try {
    await Firestore.instance.collection(_name).add(requestRow.Row(
          customer.trim().isEmpty ? '-' : customer,
          employee.trim().isEmpty ? '-' : employee,
          requiredImplementation,
          appointment,
          targetPrice < 0 ? 0 : targetPrice,
          stageIs,
          salseman.trim().isEmpty ? '-' : salseman,
          typeIs.trim().isEmpty ? '-' : typeIs,
        ).toJson());

    controlLiveVersion.save(_name);
    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> edit(
    GlobalKey<ScaffoldState> scaffoldKey,
    String key,
    String customer,
    String employee,
    String requiredImplementation,
    DateTime appointment,
    double targetPrice,
    int stageIs,
    String salseman,
    String typeIs) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData({
      "customer": customer,
      "employee": employee,
      "requiredImplementation": requiredImplementation,
      "appointment": appointment,
      "targetPrice": targetPrice,
      "stageIs": stageIs,
      "salseman": salseman,
      "typeIs": typeIs,
      "needUpdate": true,
    });

    controlLiveVersion.save(_name);
    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getToday() {
  return Firestore.instance
      .collection(_name)
      .where('appointment',
          isGreaterThanOrEqualTo: DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day,-2))
      .where(
        'appointment',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 22, 60, 60),
      )
      .snapshots();
}

Stream<QuerySnapshot> getTomorrow() {
  return Firestore.instance
      .collection(_name)
      .where('appointment',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day,-2)
              .add(Duration(days: 1)))
      .where(
        'appointment',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 22, 60, 60)
            .add(Duration(days: 1)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getPending() {
  return Firestore.instance
      .collection(_name)
      .where('statusIs', isEqualTo: 1)
      .snapshots();
}
