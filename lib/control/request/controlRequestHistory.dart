import 'package:cloud_firestore/cloud_firestore.dart';

String _name = 'requestHistory';

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getAllOrderByEmployee() {
  return Firestore.instance.collection(_name).orderBy('employee').snapshots();
}

Stream<QuerySnapshot> getAllOrderByamount() {
  return Firestore.instance.collection(_name).orderBy('amount').snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "needDelete": false,
        "deleteByUserID": 0,
        "deleteNote": '',
        "imageCount": 0,
      });
    });

    return true;
  } catch (e) {}

  return false;
}
