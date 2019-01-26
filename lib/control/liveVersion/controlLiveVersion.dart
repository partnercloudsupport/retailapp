import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myString.dart';
import 'package:retailapp/control/my/myDialog.dart' as myDialog;
import 'package:launch_review/launch_review.dart';

String _name = 'liveVersion';
String _currentVersion = '1.17';

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

    if (dr.data['version'] != _currentVersion) {
      myDialog.ReturnDialog returnDialog = await myDialog.show(
          context,
          MyLanguage.text(myLanguageItem.pleaseUpdateYourApp),
          MyLanguage.text(myLanguageItem.fromCurrentVersion) +
              ': $_currentVersion ' +
              MyLanguage.text(myLanguageItem.to).toLowerCase() +
              ' ' +
              MyString.addEnterIfNotEmpty(dr.data['version']),
          [
            myDialog.itemAction(context, MyLanguage.text(myLanguageItem.ok),
                myDialog.ReturnDialog.ok),
            myDialog.itemAction(
                context,
                MyLanguage.text(myLanguageItem.whatsNew),
                myDialog.ReturnDialog.news)
          ]);

      if (returnDialog == myDialog.ReturnDialog.news) {
        returnDialog = await myDialog.show(
            context,
            MyLanguage.text(myLanguageItem.whatsNewInThisVersion),
            MyString.addEnterIfNotEmpty(dr.data['news1']) +
                MyString.addEnterIfNotEmpty(dr.data['news2']) +
                MyString.addEnterIfNotEmpty(dr.data['news3']) +
                MyString.addEnterIfNotEmpty(dr.data['news4']) +
                MyString.addEnterIfNotEmpty(dr.data['news5']) +
                MyString.addEnterIfNotEmpty(dr.data['news6']) +
                MyString.addEnterIfNotEmpty(dr.data['news7']) +
                MyString.addEnterIfNotEmpty(dr.data['news8']) +
                dr.data['news9'],
            [
              myDialog.itemAction(context, MyLanguage.text(myLanguageItem.ok),
                  myDialog.ReturnDialog.ok)
            ]);
      }
      if (returnDialog == myDialog.ReturnDialog.ok)
        LaunchReview.launch(androidAppId: "com.smartsecurity.retailapp");
    }
  } catch (e) {}
}
