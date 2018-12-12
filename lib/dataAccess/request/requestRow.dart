import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool needDelete;
  int deleteByUserID;
  String deleteNote;

  Row(
      this.customer,
      this.employee,
      this.requiredImplementation,
      this.appointment,
      this.targetPrice,
      this.stageIs,
      this.salseman,
      this.typeIs,
      {this.needInsert = true}) {
    this.customerID = 0;
    this.employeeID = 0;
    this.haveQuotation = false;
    this.paidByEmployeeID = 0;
    this.paidByEmployee = "";
    this.amount = 0;
    this.takeIn = DateTime.now();
    this.stageIs = 3;
    this.notesCount = 0;
    this.salsemanID = 0;
    this.statusIs = 0;

    this.needUpdate = !this.needInsert;
    this.needDelete = false;
    this.deleteByUserID = 0;
    this.deleteNote = '';
  }

  Row.fromSnapshot(DocumentSnapshot dr) {
    key = dr.documentID;
    customerID = dr["customerID"];
    customer = dr["customer"];
    employeeID = dr["employeeID"];
    employee = dr["employee"];
    requiredImplementation = dr["requiredImplementation"];
    appointment = dr["appointment"];
    haveQuotation = dr["haveQuotation"];
    paidByEmployeeID = dr["paidByEmployeeID"];
    paidByEmployee = dr["paidByEmployee"];
    amount = dr["amount"];
    takeIn = dr["takeIn"];
    targetPrice = dr["targetPrice"];
    stageIs = dr["stageIs"];
    notesCount = dr["notesCount"];
    salsemanID = dr["salsemanID"];
    salseman = dr["salseman"];
    statusIs = dr["statusIs"];
    typeIs = dr["typeIs"];
    needInsert = dr["needInsert"];
    needUpdate = dr["needUpdate"];
    needDelete = dr["needDelete"];
    deleteByUserID = dr["deleteByUserID"];
    deleteNote = dr["deleteNote"];
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
      "needDelete": needDelete,
      "deleteByUserID": deleteByUserID,
      "deleteNote": deleteNote,
    };
  }
}
