import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  String customer;
  DateTime dateTimeIs;
  String noteIs;
  String phone;

  Row(this.customer, this.noteIs, this.phone) {
    dateTimeIs = DateTime.now();
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    customer = snapshot.value["customer"];
    dateTimeIs = snapshot.value["dateTimeIs"];
    noteIs = snapshot.value["noteIs"];
    phone = snapshot.value["phone"];
  }

  toJson() {
    return {
      "customer": customer,
      "dateTimeIs": dateTimeIs,
      "noteIs": noteIs,
      "phone": phone,
    };
  }
}
