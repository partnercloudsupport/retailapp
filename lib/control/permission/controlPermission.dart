import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

DocumentSnapshot drNow;
String _name = 'permission';

Future<bool> getMe() async {
  try {
    drNow = await Firestore.instance
        .collection(_name)
        .document(controlUser.drNow.data['permissionID'].toString())
        .get();

    return drNow.exists;
  } catch (e) {}

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "requestInsert": true,
        "requestEdit": true,
        "requestDelete": true
      });
    });

    return true;
  } catch (e) {}

  return false;
}
