import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/dataAccess/request/requestNoteRow.dart'
    as requestNoteRow;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:uuid/uuid.dart';

String _name = 'requestNote';

Future<bool> save(
  double requestID,
  String note,
) async {
  try {
    await Firestore.instance
        .collection(_name)
        .document(Uuid().v1())
        .setData(requestNoteRow.Row(
          requestID,
          note.trim().isEmpty ? '-' : note,
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
