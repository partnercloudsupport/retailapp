import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/dataAccess/request/requestImageRow.dart'
    as requestImageRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _name = 'requestImage';

Future<bool> save(
  double requestID,
  String pathImage,
) async {
  try {
    await Firestore.instance.collection(_name).add(requestImageRow.Row(
          requestID,
          pathImage,
        ).toJson());

    controlLiveVersion.save(_name);

    return true;
  } catch (e) {}

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
