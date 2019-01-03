import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

DocumentSnapshot drNow;

Future<bool> signInByEmail(
    GlobalKey<ScaffoldState> scaffoldKey, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return true;
  } catch (e) {
  //  mySnackBar.show1(scaffoldKey, e.toString());
    print(e.toString());
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
  //  mySnackBar.show1(scaffoldKey, e.toString());
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
        .collection('user')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .snapshots()
        .first;

    drNow = dr.documents.first;

    if (dr.documents.length != 1) {
    //  mySnackBar.show1(scaffoldKey, 'Not find this user');

      return false;
    }

    return true;
  } catch (e) {
  //  mySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> signInByAuto(
    GlobalKey<ScaffoldState> scaffoldKey, String name, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'samerbrees@gmail.com', password: '12345678');

    QuerySnapshot dr = await Firestore.instance
        .collection('user')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .snapshots()
        .first;

    drNow = dr.documents.first;
    return (dr.documents.length == 1);
  } catch (e) {
   // mySnackBar.show1(scaffoldKey, e.toString());
  }

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection('user').snapshots();
}
