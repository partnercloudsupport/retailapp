import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/dataAccess/request/requestNoteRow.dart'
    as requestNoteRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'requestNote';

Future<bool> save(
  double requestID,
  String user,
  String note,
) async {
  try {
    await Firestore.instance.collection(_name).add(requestNoteRow.Row(
          requestID,
          user.trim().isEmpty ? '-' : user,
          note.trim().isEmpty ? '-' : note,
        ).toJson());

    controlLiveVersion.save(_name);

    return true;
  } catch (e) {}

  return false;
}

Future<bool> edit(GlobalKey<ScaffoldState> scaffoldKey, String key,
    double requestID, String user, String note) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData(
        requestNoteRow.Row(requestID, user.trim().isEmpty ? '-' : user,
                note.trim().isEmpty ? '-' : note,
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
  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getOfRequest(double requestID) {
  return Firestore.instance
      .collection(_name)
      .where('requestID', isEqualTo: requestID)
      .snapshots();
}
