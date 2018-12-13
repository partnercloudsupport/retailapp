import 'package:firebase_database/firebase_database.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class Row {
  String key;
  double requestID;
  int userID;
  String user;
  int stageIs;
  DateTime dateTimeIs;
  String pathImage;
  bool needInsert;
  bool needUpdate;

  Row(this.requestID, this.pathImage, {this.needInsert = true}) {
    this.user = controlUser.drNow.data['name'];
    this.userID = 0;
    this.stageIs = 3;
    this.dateTimeIs = DateTime.now();
    this.needUpdate = !this.needInsert;
  }

  Row.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    requestID = snapshot.value["requestID"];
    userID = snapshot.value["userID"];
    user = snapshot.value["user"];
    stageIs = snapshot.value["stageIs"];
    dateTimeIs = snapshot.value["dateTimeIs"];
    pathImage = snapshot.value["pathImage"];
    needInsert = snapshot.value["needInsert"];
    needUpdate = snapshot.value["needUpdate"];
  }

  toJson() {
    return {
      "requestID": requestID,
      "userID": userID,
      "user": user,
      "stageIs": stageIs,
      "dateTimeIs": dateTimeIs,
      "pathImage": pathImage,
      "needInsert": needInsert,
      "needUpdate": needUpdate,
    };
  }
}
