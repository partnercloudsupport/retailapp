import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  String name;
  bool showInSchedule;
  bool needInsert;
  bool needUpdate;
  double totalAmountRequestD;
  String totalAmountRequestDF;

  Row(this.name, {this.needInsert = true}) {
    this.needUpdate = !this.needInsert;
    this.showInSchedule = true;
    this.totalAmountRequestD = 0.0;
    this.totalAmountRequestDF = r'0 $';

  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value["name"];
    showInSchedule = snapshot.value["showInSchedule"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
  }

  toJson() {
    return {
      "name": name,
      "showInSchedule": showInSchedule,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
    };
  }
}
