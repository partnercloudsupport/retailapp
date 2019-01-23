import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySuperTooltip.dart' as mySuperTooltip;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myString.dart' as myString;

String _name = 'liveVersion';
String _currentVersion = '1.14';

Future<bool> save(String document) async {
  try {
    String _version = DateTime.now().millisecondsSinceEpoch.toString();

    await Firestore.instance
        .collection(_name)
        .document(document)
        .updateData({"version": _version});

    await Firestore.instance
        .collection(_name)
        .document('all')
        .updateData({"version": _version});

    return true;
  } catch (e) {}

  return false;
}

void checkupVersion(BuildContext context) async {
  try {
    DocumentSnapshot dr = await Firestore.instance
        .collection(_name)
        .document('appOnGoogle')
        .get();

    if (dr.data['version'] != _currentVersion)
      mySuperTooltip.show1(
          context,
          myLanguage.text(myLanguage.item.pleaseUpdateYourApp) +
              '\n\n\r   ' +
              myLanguage
                  .text(myLanguage.item.fromCurrentVersion)
                  .toLowerCase() +
              ': $_currentVersion\n\r   ' +
              myLanguage.text(myLanguage.item.toTheNewVersion).toLowerCase() +
              ': ' +
              myString.addEnterIfNotEmpty(dr.data['version']) +
              myString.insertEnterIfNotEmpty(dr.data['news1']) +
              myString.insertEnterIfNotEmpty(dr.data['news2']) +
              myString.insertEnterIfNotEmpty(dr.data['news3']) +
              myString.insertEnterIfNotEmpty(dr.data['news4']) +
              myString.insertEnterIfNotEmpty(dr.data['news5']) +
              myString.insertEnterIfNotEmpty(dr.data['news6']) +
              myString.insertEnterIfNotEmpty(dr.data['news7']) +
              myString.insertEnterIfNotEmpty(dr.data['news8']) +
              myString.insertEnterIfNotEmpty(dr.data['news9']));
  } catch (e) {}
}
