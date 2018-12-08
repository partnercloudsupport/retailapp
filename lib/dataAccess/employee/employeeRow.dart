import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  String name;
  bool showInSchedule;
  bool needInsert;
  bool needUpdate;

  Row(this.name, {this.needInsert = true}) {
    this.needUpdate = !this.needInsert;
    this.showInSchedule = true;
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
