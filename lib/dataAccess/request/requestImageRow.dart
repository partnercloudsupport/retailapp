import 'package:firebase_database/firebase_database.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class Row {
  String key;
  String name;
  double requestID;
  int userID;
  String user;
  int stageIs;
  DateTime dateTimeIs;
  String note;
  String pathImage;
  bool needInsert;
  bool needUpdate;
  bool needDelete;
  int deleteByUserID;
  bool isPrivate;

  Row(this.name, this.requestID, this.note, this.pathImage, this.isPrivate,
      {this.needInsert = true}) {
    this.user = controlUser.drNow.data['name'];
    this.userID = int.parse(controlUser.drNow.documentID);
    this.stageIs = 3;
    this.dateTimeIs = DateTime.now();
    this.needUpdate = !this.needInsert;
    this.needDelete = false;
    this.deleteByUserID = int.parse(controlUser.drNow.documentID);
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value["name"];
    requestID = snapshot.value["requestID"];
    userID = snapshot.value["userID"];
    user = snapshot.value["user"];
    stageIs = snapshot.value["stageIs"];
    dateTimeIs = snapshot.value["dateTimeIs"];
    note = snapshot.value["note"];
    pathImage = snapshot.value["pathImage"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
    needDelete = snapshot.value["needDelete"];
    deleteByUserID = snapshot.value["deleteByUserID"];
    isPrivate = snapshot.value["isPrivate"];
  }

  toJson() {
    return {
      "name": name,
      "requestID": requestID,
      "userID": userID,
      "user": user,
      "stageIs": stageIs,
      "dateTimeIs": dateTimeIs,
      "note": note,
      "pathImage": pathImage,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
      "needDelete": needDelete,
      "deleteByUserID": deleteByUserID,
      "isPrivate": isPrivate,
    };
  }
}
