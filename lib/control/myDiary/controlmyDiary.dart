import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/dataAccess/myDiary/myDiaryRow.dart' as myDiaryRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:uuid/uuid.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

String _name = 'myDiary';

Future<bool> save(
    GlobalKey<ScaffoldState> scaffoldKey,
    String customer,
    DateTime beginDate,
    DateTime endDate,
    String note,
    double amount,
    int typeIs,
    GeoPoint mapLocation,
    int saveFrom) async {
  try {
    await Firestore.instance.collection(_name).document(Uuid().v1()).setData(
        myDiaryRow.Row(customer, beginDate, endDate, note, amount, typeIs,
                mapLocation, saveFrom)
            .toJson());

    controlLiveVersion.save(_name);
    mySnackBar.show(
        scaffoldKey, myLanguage.text(myLanguage.item.saveSuccessfully));
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
    DateTime beginDate,
    DateTime endDate,
    String note,
    double amount,
    int typeIs,
    GeoPoint mapLocation,
    int saveFrom) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData(
        myDiaryRow.Row(customer, beginDate, endDate, note, amount, typeIs,
                mapLocation, saveFrom,
                needInsert: false)
            .toJson());

    controlLiveVersion.save(_name);
    mySnackBar.show(
        scaffoldKey, myLanguage.text(myLanguage.item.saveSuccessfully));
    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> delete(String key) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData({
      "needDelete": true,
      "deleteByUserID": controlUser.drNow.documentID,
    });
    controlLiveVersion.save(_name);
    return true;
  } catch (e) {}

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getByMe() {
  return Firestore.instance
      .collection(_name)
      .where('userID', isEqualTo: controlUser.drNow.documentID)
      .snapshots();
}
