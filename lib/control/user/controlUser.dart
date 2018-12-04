import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

Future<bool> signIn(
    String email, String password, GlobalKey<ScaffoldState> scaffoldKey) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> create(
    String email, String password, GlobalKey<ScaffoldState> scaffoldKey) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    mySnackBar.show(
        scaffoldKey,
        myLanguage
            .text(myLanguage.TextIndex.yourAccountWasSuccessfullyCreated));

    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Future<bool> signOut(GlobalKey<ScaffoldState> scaffoldKey) async {
  try {
    await FirebaseAuth.instance.signOut();

    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }
  return false;
}
