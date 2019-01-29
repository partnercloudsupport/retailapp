import 'package:cloud_firestore/cloud_firestore.dart';

String _name = 'employeeRequestMonthlyReport';

Stream<QuerySnapshot> getAll() {
  return Firestore.instance.collection(_name).snapshots();
}

Stream<QuerySnapshot> getOrderByMonthYearNumber() {
  return Firestore.instance
      .collection(_name)
      .orderBy('monthYearNumber', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getByFilterEmployee(int id) {
  return Firestore.instance.collection(_name).snapshots();
}

Future<double> getTotalOfEmployee(
    int id, int fromMonthYearNumber, int toMonthYearNumber) async {
  var drs = await Firestore.instance
      .collection(_name)
      .where('employeeID', isEqualTo: id)
      .where('monthYearNumber', isGreaterThanOrEqualTo: fromMonthYearNumber)
      .where('monthYearNumber', isLessThanOrEqualTo: toMonthYearNumber)
      .getDocuments();

  double total = 0;
  drs.documents.forEach((v) {
    total += v.data['amountD'];
  });

  return total;
}

Future<double> getAllTotal() async {
  var drs = await Firestore.instance.collection(_name).getDocuments();

  double total = 0;
  drs.documents.forEach((v) {
    total += v.data['amountD'];
  });

  return total;
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
