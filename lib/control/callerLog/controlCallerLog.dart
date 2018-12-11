import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/dataAccess/callerLog/callerLogRow.dart'
    as callerLogRow;

String _name = 'callerLog';

Future<bool> save(GlobalKey<ScaffoldState> scaffoldKey, String customer,
    String noteIs, String phone) async {
  try {
    await Firestore.instance
        .collection(_name)
        .add(callerLogRow.Row(customer, noteIs, phone).toJson());
    mySnackBar.show(
        scaffoldKey, myLanguage.text(myLanguage.item.saveSuccessfully));
    return true;
  } catch (e) {
    mySnackBar.show(scaffoldKey, e.toString());
  }

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getToday() {
  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .where('dateTimeIs',
          isGreaterThanOrEqualTo: DateTime.utc(
              DateTime.now().year, DateTime.now().month, DateTime.now().day))
      .snapshots();
}

Stream<QuerySnapshot> getYesterday() {
  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .where('dateTimeIs',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: -1)))
      .where(
        'dateTimeIs',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
            .add(Duration(days: -1)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getLastWeek() {
  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .where('dateTimeIs',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: -9)))
      .where(
        'dateTimeIs',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
            .add(Duration(days: -2)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getAllBeforeLastWeek() {
  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .where(
        'dateTimeIs',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
            .add(Duration(days: -9)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getBetweenData(DateTime fromDate, DateTime toDate) {
  fromDate = myDateTime.fixDateToDay(fromDate);
  toDate = myDateTime.fixDateToDay(toDate);

  if (fromDate.isAfter(toDate)) {
    DateTime v = fromDate;
    fromDate = toDate;
    toDate = v;
  }

  return Firestore.instance
      .collection(_name)
      .orderBy('dateTimeIs', descending: true)
      .where('dateTimeIs',
          isGreaterThanOrEqualTo:
              DateTime.utc(fromDate.year, fromDate.month, fromDate.day))
      .where(
        'dateTimeIs',
        isLessThanOrEqualTo:
            DateTime.utc(toDate.year, toDate.month, toDate.day, 24, 60, 60),
      )
      .snapshots();
}
