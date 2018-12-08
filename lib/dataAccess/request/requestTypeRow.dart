import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  String name;
  bool needInsert;
  bool needUpdate;

  Row(this.name, {this.needInsert = true}) {
    this.needUpdate = !this.needInsert;
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value["name"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
  }

  toJson() {
    return {
      "name": name,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
    };
  }
}
