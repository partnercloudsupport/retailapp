import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myPermission.dart';
import 'package:retailapp/dataAccess/myDiary/myDiaryRow.dart' as myDiaryRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:uuid/uuid.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/MyLocation.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myLanguage.dart';

String _name = 'myDiary';

enum TypeIs { showroom, outgoingCall, visitCustomer }

enum TypeView {
  today,
  yesterday,
  lastWeek,
  all,
}

TypeIs typeCast(int i) {
  switch (i) {
    case 0:
      return TypeIs.showroom;
      break;
    case 1:
      return TypeIs.outgoingCall;
      break;
    case 2:
      return TypeIs.visitCustomer;
      break;
    default:
      return TypeIs.showroom;
  }
}

Widget buildType(int v, Color color) {
  String t = 'lib/res/image/Prospect_001_32.png';

  switch (v) {
    case 0:
      t = 'lib/res/image/Company_002_32.png';
      break;
    case 1:
      t = 'lib/res/image/CallerID_003_32.png';
      break;
    case 2:
      t = 'lib/res/image/Outdoor_001_32.png';
      break;
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Image.asset(
      t,
      color: color,
      height: 16.0,
      width: 16.0,
    ),
  );
}

Future<bool> save(
    GlobalKey<ScaffoldState> scaffoldKey,
    String customer,
    DateTime beginDate,
    DateTime endDate,
    String note,
    double amountQuotation,
    double amount,
    int typeIs) async {
  try {
    if (await MyPermission.checkPermissionThenrequest(
            scaffoldKey, MyPermissionItem.location) ==
        false) return false;

    GeoPoint mapLocation = await MyLocation.getByGeoPoint();

    await Firestore.instance.collection(_name).document(Uuid().v1()).setData(
        myDiaryRow.Row(customer, beginDate, endDate, note, amountQuotation,
                amount, typeIs,
                mapLocation: mapLocation, saveFrom: 1)
            .toJson());

    controlLiveVersion.save(_name);
    MySnackBar
        .showInHomePage1(MyLanguage.text(myLanguageItem.saveSuccessfully));
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
    DateTime beginDate,
    DateTime endDate,
    String note,
    double amountQuotation,
    double amount,
    int typeIs) async {
  try {
    await Firestore.instance
        .collection(_name)
        .document(key)
        .updateData(myDiaryRow.RowEdit(
          customer,
          beginDate,
          endDate,
          note,
          amountQuotation,
          amount,
          typeIs,
        ).toJson());

    controlLiveVersion.save(_name);
    return true;
  } catch (e) {
    MySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> delete(GlobalKey<ScaffoldState> scaffoldKey, String key) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData({
      "needDelete": true,
      "deleteByUserID": controlUser.drNow.documentID,
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

Stream<QuerySnapshot> getAllOrderByUser() {
  return Firestore.instance
      .collection(_name)
      .orderBy('user', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getAllOrderByamount() {
  return Firestore.instance
      .collection(_name)
      .orderBy('amount', descending: true)
      .snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "amountQuotation": 0.0,
        "amountQuotationF": r'0 $',
        "amountRemaining": 0.0,
        "amountRemainingF": r'0 $',
      });
    });

    return true;
  } catch (e) {}

  return false;
}
