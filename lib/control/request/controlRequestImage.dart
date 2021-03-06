import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/dataAccess/request/requestImageRow.dart'
    as requestImageRow;
import 'package:retailapp/control/my/myString.dart';
import 'package:uuid/uuid.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

String _name = 'requestImage';

Future<bool> saveByPath(
  double requestID,
  String note,
  String pathImage,
  bool isPrivate,
) async {
  try {
    String id = Uuid().v1();
    String name = id + MyString.getExtensionWithDot(pathImage);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(_name + '/' + id);

    StorageUploadTask uploadTask = reference.putFile(File(pathImage));

    uploadTask.onComplete.whenComplete(() async {
      await Firestore.instance
          .collection(_name)
          .document(id)
          .setData(requestImageRow.Row(
            name,
            requestID,
            note,
            await reference.getDownloadURL(),
            isPrivate,
          ).toJson());
    });
    return true;
  } catch (e) {}

  return false;
}

Future<bool> saveByAsset(
  double requestID,
  String note,
  Asset asset,
  bool isPrivate,
) async {
  try {
    String id = Uuid().v1();
    String name = id + '.png';
    StorageReference reference =
        FirebaseStorage.instance.ref().child(_name + '/' + id);
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageUploadTask uploadTask = reference.putData(imageData);
    uploadTask.onComplete.whenComplete(() async {
      await Firestore.instance
          .collection(_name)
          .document(id)
          .setData(requestImageRow.Row(
            name,
            requestID,
            note,
            await reference.getDownloadURL(),
            isPrivate,
          ).toJson());
    });
    asset.releaseOriginal();
    return true;
  } catch (e) {}

  return false;
}

Future<bool> saveByFile(
  double requestID,
  String note,
  File image,
  bool isPrivate,
) async {
  try {
    String id = Uuid().v1();
    String name = id + '.png';
    StorageReference reference =
        FirebaseStorage.instance.ref().child(_name + '/' + id);

    StorageUploadTask uploadTask = reference.putFile(image);

    uploadTask.onComplete.whenComplete(() async {
      await Firestore.instance
          .collection(_name)
          .document(id)
          .setData(requestImageRow.Row(
            name,
            requestID,
            note,
            await reference.getDownloadURL(),
            isPrivate,
          ).toJson());
    });
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
      .orderBy('dateTimeIs', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getOfRequest(double requestID) {
  return Firestore.instance
      .collection(_name)
      .where('requestID', isEqualTo: requestID)
      .snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData(
              {"needDelete": false, "deleteByUserID": 0, "isPrivate": false});
    });

    return true;
  } catch (e) {}

  return false;
}
