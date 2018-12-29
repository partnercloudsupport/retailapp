import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

String _name = 'callerLog';

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
  fromDate = myDateTime.toMe(fromDate);
  toDate = myDateTime.toMe(toDate);

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
