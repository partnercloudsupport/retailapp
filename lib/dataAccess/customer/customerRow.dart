import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.needUpdate = !this.needInsert;
  }

  Row.fromSnapshot(DocumentSnapshot snapshot) {
    key = snapshot.documentID;
    name = snapshot["name"];
    phones = snapshot["phones"];
    address = snapshot["address"];
    email = snapshot["email"];
    note = snapshot["note"];
    mapLocation = snapshot["mapLocation"];
    needInsert = snapshot["needInsert"];
    needUpdate = snapshot["needUpdate"];
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

  toJsonEditLocation(GeoPoint mapLocation) {
    return {
      "mapLocation": mapLocation,
      "needUpdate": true,
    };
  }
}

class EditMapLocation {
  String key;
  GeoPoint mapLocation;
  bool needUpdate = true;

  EditMapLocation(this.mapLocation);

  toJson() {
    return {
      "mapLocation": mapLocation,
      "needUpdate": needUpdate,
    };
  }
}
