import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/dataAccess/request/requestImageRow.dart'
    as requestImageRow;
import 'package:retailapp/control/my/myString.dart' as myString;

String _name = 'requestImage';

Future<bool> save(
  double requestID,
  String note,
  String pathImage,
) async {
  try {
    String name =
        DateTime.now().toString() + myString.getExtensionWithDot(pathImage);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(_name + '/' + name);

    StorageUploadTask uploadTask = reference.putFile(File(pathImage));

    uploadTask.onComplete.whenComplete(() async {
      await Firestore.instance.collection(_name).add(requestImageRow.Row(
            name,
            requestID,
            note,
            await reference.getDownloadURL(),
          ).toJson());
    });

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
