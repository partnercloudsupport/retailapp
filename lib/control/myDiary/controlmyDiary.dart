import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/dataAccess/myDiary/myDiaryRow.dart' as myDiaryRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:uuid/uuid.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLocation.dart' as myLocation;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

String _name = 'myDiary';

enum TypeIs { showroom, outgoingCall, visitCustomer }

Future<bool> save(String customer, DateTime beginDate, DateTime endDate,
    String note, double amount, int typeIs) async {
  try {
    GeoPoint mapLocation = await myLocation.getByGeoPoint();

    await Firestore.instance.collection(_name).document(Uuid().v1()).setData(
        myDiaryRow.Row(customer, beginDate, endDate, note, amount, typeIs,
                mapLocation: mapLocation, saveFrom: 1)
            .toJson());

    controlLiveVersion.save(_name);

    return true;
  } catch (e) {}

  return false;
}

Future<bool> edit(String key, String customer, DateTime beginDate,
    DateTime endDate, String note, double amount, int typeIs) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData(
        myDiaryRow.Row(customer, beginDate, endDate, note, amount, typeIs,
                needInsert: false)
            .toJsonEdit());

    controlLiveVersion.save(_name);
    return true;
  } catch (e) {}

  return false;
}

Future<bool> delete(String key) async {
  try {
    await Firestore.instance.collection(_name).document(key).updateData({
      "needDelete": true,
      "deleteByUserID": controlUser.drNow.documentID,
    });
    controlLiveVersion.save(_name);
    return true;
  } catch (e) {}

  return false;
}

Stream<QuerySnapshot> getAll() {
  return Firestore.instance
      .collection(_name)
      .orderBy('beginDate', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getToday() {
  return Firestore.instance
      .collection(_name)
      .orderBy('beginDate', descending: true)
      .where('beginDate',
          isGreaterThanOrEqualTo: DateTime.utc(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, -2))
      .where(
        'beginDate',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 22, 60, 60),
      )
      .snapshots();
}

Stream<QuerySnapshot> getYesterday() {
  return Firestore.instance
      .collection(_name)
      .orderBy('beginDate', descending: true)
      .where('beginDate',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: -1)))
      .where(
        'beginDate',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
            .add(Duration(days: -1)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getLastWeek() {
  return Firestore.instance
      .collection(_name)
      .orderBy('beginDate', descending: true)
      .where('beginDate',
          isGreaterThanOrEqualTo: DateTime.utc(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(Duration(days: -9)))
      .where(
        'beginDate',
        isLessThanOrEqualTo: DateTime.utc(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 24, 60, 60)
            .add(Duration(days: -2)),
      )
      .snapshots();
}

Stream<QuerySnapshot> getAllBeforeLastWeek() {
  return Firestore.instance
      .collection(_name)
      .orderBy('beginDate', descending: true)
      .where(
        'beginDate',
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
      .orderBy('beginDate', descending: true)
      .where('beginDate',
          isGreaterThanOrEqualTo:
              DateTime.utc(fromDate.year, fromDate.month, fromDate.day))
      .where(
        'beginDate',
        isLessThanOrEqualTo:
            DateTime.utc(toDate.year, toDate.month, toDate.day, 24, 60, 60),
      )
      .snapshots();
}

TypeIs typeIsCast(int i) {
  switch (i) {
    case 0:
      return TypeIs.showroom;
      break;
    case 1:
      return TypeIs.outgoingCall;
      break;
    case 2:
      return TypeIs.visitCustomer;
      break;
    default:
      return TypeIs.showroom;
  }
}
