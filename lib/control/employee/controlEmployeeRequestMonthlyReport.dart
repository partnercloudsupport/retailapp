import 'package:cloud_firestore/cloud_firestore.dart';

String _name = 'employeeRequestMonthlyReport';

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getOrderByMonthYearNumber() {
  return Firestore.instance
      .collection(_name)
      .orderBy('monthYearNumber' ,descending: true)
      .snapshots();
}

Future<bool> addSomeColumn() async {
  try {
    var i = await Firestore.instance.collection(_name).getDocuments();

    i.documents.forEach((ii) async {
      await Firestore.instance
          .collection(_name)
          .document(ii.documentID)
          .updateData({
        "": 0.0,
      });
    });

    return true;
  } catch (e) {}

  return false;
}
