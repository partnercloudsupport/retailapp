import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/dataAccess/customer/customerRow.dart' as customerRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'customer';

Future<bool> save(
    GlobalKey<ScaffoldState> scaffoldKey,
    String name,
    String phones,
    String address,
    String email,
    String note,
    GeoPoint mapLocation) async {
  try {
    await Firestore.instance.collection(_name).add(
        customerRow.Row(name, phones, address, email, note, mapLocation)
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

Future<bool> edit(
    GlobalKey<ScaffoldState> scaffoldKey,
    String key,
    String name,
    String phones,
    String address,
    String email,
    String note,
    GeoPoint mapLocation) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData(
        customerRow.Row(name, phones, address, email, note, mapLocation,
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

Stream<QuerySnapshot> getByFilter(String v) {
  return Firestore.instance
      .collection(_name)
      .where('name', isEqualTo: v)
      .snapshots();
}
