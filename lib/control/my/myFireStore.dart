import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/my/myTypes.dart' as myTypes;

Stream<QuerySnapshot> getData(String tableName, String sortBy,
    {bool sortDescending = false,
    myTypes.MyFilterItem typeFilter = myTypes.MyFilterItem.none,
    String filterColumn = '',
    String filter1 = '',
    String filter2 = ''}) {
  if (typeFilter == myTypes.MyFilterItem.none) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .snapshots();
  } else if (typeFilter == myTypes.MyFilterItem.equal) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .where(filterColumn, isEqualTo: filter1)
        .snapshots();
  } else if (typeFilter == myTypes.MyFilterItem.range) {
    return Firestore.instance
        .collection(tableName)
        .orderBy(sortBy, descending: sortDescending)
        .where(filterColumn, isEqualTo: filter1)
        .snapshots();
  }

  return null;
}
