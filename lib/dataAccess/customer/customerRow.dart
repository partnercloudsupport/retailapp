import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  String name;
  String phones;
  String address;
  String email;
  String note;
  GeoPoint mapLocation;
  bool needInsert;
  bool needUpdate;

  Row(this.name, this.phones, this.address, this.email, this.note,
      this.mapLocation,
      {this.needInsert = true}) {
    this.needUpdate = true;
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value["name"];
    phones = snapshot.value["phones"];
    address = snapshot.value["address"];
    email = snapshot.value["email"];
    note = snapshot.value["note"];
    mapLocation = snapshot.value["mapLocation"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
  }

  toJson() {
    return {
      "name": name,
      "phones": phones,
      "address": address,
      "email": email,
      "note": note,
      "mapLocation": mapLocation,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
    };
  }
}
