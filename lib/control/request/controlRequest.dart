import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
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
          customer,
          employee,
          requiredImplementation,
          appointment,
          targetPrice,
          stageIs,
          salseman,
          typeIs,
        ).toJson());
    mySnackBar.show(
        scaffoldKey, myLanguage.text(myLanguage.TextIndex.saveSuccessfully));
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
    await Firestore.instance.collection(_name).document(key).updateData(
        requestRow.Row(customer, employee, requiredImplementation, appointment,
                targetPrice, stageIs, salseman, typeIs,
                needInsert: false)
            .toJson());

    controlLiveVersion.save(_name);
    mySnackBar.show(
        scaffoldKey, myLanguage.text(myLanguage.TextIndex.saveSuccessfully));
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
              DateTime.now().year, DateTime.now().month, DateTime.now().day))
      .where(
        'appointment',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 24, 60, 60),
      )
      .snapshots();
}

Stream<QuerySnapshot> getTomorrow() {
  return Firestore.instance
      .collection(_name)
      .where('appointment',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: 1)))
      .where(
        'appointment',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
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
