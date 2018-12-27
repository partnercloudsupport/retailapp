import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/dataAccess/myDiary/myDiaryRow.dart' as myDiaryRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:uuid/uuid.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLocation.dart' as myLocation;

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
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getByMe() {
  int userID = int.parse(controlUser.drNow.documentID);

  return Firestore.instance
      .collection(_name)
      .where('userID', isEqualTo: userID)
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
