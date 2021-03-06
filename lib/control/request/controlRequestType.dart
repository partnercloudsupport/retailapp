import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/dataAccess/request/requestTypeRow.dart'
    as requestTypeRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'requestType';

Future<bool> save(GlobalKey<ScaffoldState> scaffoldKey, String name) async {
  try {
    await Firestore.instance
        .collection(_name)
        .add(requestTypeRow.Row(name).toJson());

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
        .updateData(requestTypeRow.Row(name, needInsert: false).toJson());

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
