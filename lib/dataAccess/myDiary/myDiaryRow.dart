import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

class Row {
  String key;
  bool needInsert;
  bool needUpdate;
  bool needDelete;
  int deleteByUserID;
  int customerID;
  String customer;
  int userID;
  String user;
  DateTime beginDate;
  DateTime endDate;
  String durationHourF;
  String note;
  double amount;
  String amountF;
  int typeIs;
  GeoPoint mapLocation;
  int saveFrom;

  Row(this.customer, this.beginDate, this.endDate, this.note, this.amount,
      this.typeIs,
      {this.mapLocation = const GeoPoint(1, 1),
      this.saveFrom = 0,
      this.needInsert = true}) {
    DateTime fixDate = beginDate;
    beginDate = myDateTime.getLess(beginDate, endDate);
    endDate = myDateTime.getBiggest(fixDate, endDate);

    this.needUpdate = !this.needInsert;
    this.needDelete = false;
    this.deleteByUserID = 0;
    this.customerID = 0;
    this.userID = int.parse(controlUser.drNow.documentID);
    this.user = controlUser.drNow.data['name'];
    this.durationHourF = '...';
    this.amountF = this.amount.toStringAsFixed(0) + r' $';
  }

  Row.fromSnapshot(DocumentSnapshot dr) {
    key = dr.documentID;
    needInsert = dr["needInsert"];
    needUpdate = dr["needUpdate"];
    needDelete = dr["needDelete"];
    deleteByUserID = dr["deleteByUserID"];
    customerID = dr["customerID"];
    customer = dr["customer"];
    userID = dr["userID"];
    user = dr["user"];
    beginDate = dr["beginDate"];
    endDate = dr["endDate"];
    durationHourF = dr["durationHourF"];
    note = dr["note"];
    amount = dr["amount"];
    amountF = dr["amountF"];
    typeIs = dr["typeIs"];
    mapLocation = dr["mapLocation"];
    saveFrom = dr["saveFrom"];
  }

  dynamic toJson() {
    return {
      "needInsert": needInsert,
      "needUpdate": needUpdate,
      "needDelete": needDelete,
      "deleteByUserID": deleteByUserID,
      "customerID": customerID,
      "customer": customer,
      "userID": userID,
      "user": user,
      "beginDate": beginDate,
      "endDate": endDate,
      "durationHourF": durationHourF,
      "note": note,
      "amount": amount,
      "amountF": amountF,
      "typeIs": typeIs,
      "mapLocation": mapLocation,
      "saveFrom": saveFrom,
    };
  }

  dynamic toJsonEdit() {
    return {
      "needUpdate": needUpdate,
      "customer": customer,
      "userID": userID,
      "user": user,
      "beginDate": beginDate,
      "endDate": endDate,
      "note": note,
      "amount": amount,
      "amountF": amountF,
      "typeIs": typeIs,
    };
  }
}
