import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/dataAccess/employee/employeeRow.dart' as employeeRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'employee';

Future<bool> save(GlobalKey<ScaffoldState> scaffoldKey, String name) async {
  try {
    await Firestore.instance
        .collection(_name)
        .add(employeeRow.Row(name).toJson());

    controlLiveVersion.save(_name);
    MySnackBar.show1(
        scaffoldKey, MyLanguage.text(myLanguageItem.saveSuccessfully));
    return true;
  } catch (e) {
    MySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> edit(
    GlobalKey<ScaffoldState> scaffoldKey, String key, String name) async {
  try {
    await Firestore.instance
        .collection(_name)
        .document(key)
        .updateData(employeeRow.Row(name, needInsert: false).toJson());

    controlLiveVersion.save(_name);
    MySnackBar.show1(
        scaffoldKey, MyLanguage.text(myLanguageItem.saveSuccessfully));
    return true;
  } catch (e) {
    MySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getShowInSchedule() {
  return Firestore.instance
      .collection(_name)
      .where('showInSchedule', isEqualTo: true)
      .snapshots();
}

Stream<QuerySnapshot> getAllOrderByTotalAmountRequestD() {
  return Firestore.instance
      .collection(_name)
      .orderBy('totalAmountRequestD', descending: true)
      .snapshots();
}

Future<String> getKey(String v) async {
  try {
    QuerySnapshot dr = await Firestore.instance
        .collection(_name)
        .where('name', isEqualTo: v)
        .snapshots()
        .first;

    return dr.documents.first.documentID;
  } catch (e) {
    return "";
  }
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "totalAmountRequestD": 0.0,
        "totalAmountRequestDF": r'0 $',
      });
    });

    return true;
  } catch (e) {}

  return false;
}
