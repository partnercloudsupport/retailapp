import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/myTypes.dart' as myTypes;

Stream<QuerySnapshot> getData(String tableName, String sortBy,
    {bool sortDescending = false,
    myTypes.Filter typeFilter = myTypes.Filter.none,
    String filterColumn = '',
    String filter1 = '',
    String filter2 = ''}) {
  if (typeFilter == myTypes.Filter.none) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .snapshots();
  } else if (typeFilter == myTypes.Filter.equal) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .where(filterColumn, isEqualTo: filter1)
        .snapshots();
  } else if (typeFilter == myTypes.Filter.range) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .where(filterColumn, isEqualTo: filter1)
        .snapshots();
  }

  return null;
}
