import 'package:firebase_database/firebase_database.dart';

class Row {
  String key;
  int customerID;
  String customer;
  int employeeID;
  String employee;
  String requiredImplementation;
  DateTime appointment;
  bool haveQuotation;
  int paidByEmployeeID;
  String paidByEmployee;
  double amount;
  DateTime takeIn;
  double targetPrice;
  int stageIs;
  int notesCount;
  int salsemanID;
  String salseman;
  int statusIs;
  String typeIs;
  bool needInsert;
  bool needUpdate;

  Row(this.customer, this.employee, this.requiredImplementation,
      this.appointment, this.targetPrice, this.stageIs, this.salseman,this.typeIs,
      {this.needInsert = true}) {
    this.customerID = 0;
    this.employeeID = 0;
    this.haveQuotation = false;
    this.paidByEmployeeID = 0;
    this.paidByEmployee = "";
    this.amount = 0;
    this.takeIn = DateTime.now();
    this.notesCount = 0;
    this.salsemanID = 0;
    this.statusIs = 0;

    this.needUpdate = !this.needInsert;
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    customerID = snapshot.value["customerID"];
    customer = snapshot.value["customer"];
    employeeID = snapshot.value["employeeID"];
    employee = snapshot.value["employee"];
    requiredImplementation = snapshot.value["requiredImplementation"];
    appointment = snapshot.value["appointment"];
    haveQuotation = snapshot.value["haveQuotation"];
    paidByEmployeeID = snapshot.value["paidByEmployeeID"];
    paidByEmployee = snapshot.value["paidByEmployee"];
    amount = snapshot.value["amount"];
    takeIn = snapshot.value["takeIn"];
    targetPrice = snapshot.value["targetPrice"];
    stageIs = snapshot.value["stageIs"];
    notesCount = snapshot.value["notesCount"];
    salsemanID = snapshot.value["salsemanID"];
    salseman = snapshot.value["salseman"];
    statusIs = snapshot.value["statusIs"];
    typeIs = snapshot.value["typeIs"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
  }

  toJson() {
    return {
      "customerID": customerID,
      "customer": customer,
      "employeeID": employeeID,
      "employee": employee,
      "requiredImplementation": requiredImplementation,
      "appointment": appointment,
      "haveQuotation": haveQuotation,
      "paidByEmployeeID": paidByEmployeeID,
      "paidByEmployee": paidByEmployee,
      "amount": amount,
      "takeIn": takeIn,
      "targetPrice": targetPrice,
      "stageIs": stageIs,
      "notesCount": notesCount,
      "salsemanID": salsemanID,
      "salseman": salseman,
      "statusIs": statusIs,
      "typeIs": typeIs,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
    };
  }
}
