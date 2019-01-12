import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;

String _name = 'user';
DocumentSnapshot drNow;

Future<bool> signInByEmail(
    GlobalKey<ScaffoldState> scaffoldKey, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return true;
  } catch (e) {
    mySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> createByEmail(
    GlobalKey<ScaffoldState> scaffoldKey, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    mySnackBar.show1(scaffoldKey,
        myLanguage.text(myLanguage.item.yourAccountWasSuccessfullyCreated));

    return true;
  } catch (e) {
    mySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> signOutByEmail(
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  try {
    await FirebaseAuth.instance.signOut();

    return true;
  } catch (e) {
    mySnackBar.show1(scaffoldKey, e.toString());
  }
  return false;
}

Future<bool> signIn(
    GlobalKey<ScaffoldState> scaffoldKey, String name, String password) async {
  try {
    QuerySnapshot dr = await Firestore.instance
        .collection(_name)
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .snapshots()
        .first;

    if (dr.documents.length != 1) {
      mySnackBar.show1(scaffoldKey,
          myLanguage.text(myLanguage.item.yourNameOrPasswordIsNotCorrect));

      return false;
    }
    drNow = dr.documents.first;

    drNow = await Firestore.instance
        .collection(_name)
        .document(drNow.documentID)
        .get();

    if (await controlPermission.getMe() == false) {
      mySnackBar.show1(scaffoldKey,
          myLanguage.text(myLanguage.item.weCantGetPermissionForYou));

      return false;
    }

    return true;
  } catch (e) {
    mySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> signInByAuto(String name, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'samerbrees@gmail.com', password: '12345678');

    QuerySnapshot dr = await Firestore.instance
        .collection(_name)
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .snapshots()
        .first;

    drNow = dr.documents.first;
    return (dr.documents.length == 1 && await controlPermission.getMe());
  } catch (e) {}

  return false;
}

Future<bool> getMe() async {
  try {
    drNow = await Firestore.instance
        .collection(_name)
        .document(drNow.documentID)
        .get();
    return drNow.exists;
  } catch (e) {}

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getAllOrderByName() {
  return Firestore.instance.collection(_name).orderBy('name').snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "isEnabled": true,
      });
    });
    print('Saved');
    return true;
  } catch (e) {
    print(e.toString());
  }

  return false;
}
