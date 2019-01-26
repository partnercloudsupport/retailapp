import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/dataAccess/request/requestRow.dart' as requestRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

String _name = 'request';

enum TypeView {
  today,
  tomorrow,
  pending,
  all,
}

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
    MySnackBar.show1(scaffoldKey, e.toString());
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
      "customer": customer.trim().isEmpty ? '-' : customer,
      "employee": employee.trim().isEmpty ? '-' : employee,
      "requiredImplementation": requiredImplementation,
      "appointment": appointment,
      "targetPrice": targetPrice,
      "stageIs": stageIs,
      "salseman": salseman.trim().isEmpty ? '-' : salseman,
      "typeIs": typeIs.trim().isEmpty ? '-' : typeIs,
      "needUpdate": true,
      "deleteByUserID": int.parse(controlUser.drNow.documentID),
    });

    controlLiveVersion.save(_name);
    return true;
  } catch (e) {
    MySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> win(GlobalKey<ScaffoldState> scaffoldKey, String key,
    String paidByEmployee, double amount, String deleteNote) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData({
      "paidByEmployee": paidByEmployee.trim().isEmpty ? '-' : paidByEmployee,
      "amount": amount,
      "statusIs": 4,
      "needDelete": true,
      "deleteByUserID": controlUser.drNow.documentID,
      "deleteNote": deleteNote,
    });
    controlLiveVersion.save(_name);
    return true;
  } catch (e) {
    MySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getAllOrderByEmployee() {
  return Firestore.instance.collection(_name).orderBy('employee').snapshots();
}

Stream<QuerySnapshot> getTomorrow() {
  return Firestore.instance
      .collection(_name)
      .where('appointment',
          isGreaterThanOrEqualTo: DateTime.utc(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, -2)
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

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection('request').getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection('request')
          .document(ii.documentID)
          .updateData({
        "needDelete": false,
        "deleteByUserID": 0,
        "deleteNote": '',
        "imageCount": 0,
      });
    });

    return true;
  } catch (e) {}

  return false;
}
