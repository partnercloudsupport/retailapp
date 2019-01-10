import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class RowNew {
  String key;
  bool needUpdate;
  int updateByUserID;
  String customer;
  DateTime dateTimeIs;
  String noteIs;
  String phone;
  bool isLinkWithRequest;

  RowNew(this.customer, this.noteIs, this.phone) {
    dateTimeIs = DateTime.now();
    needUpdate = false;
    updateByUserID = 0;
    isLinkWithRequest = false;
  }

  toJson() {
    return {
      "needUpdate": needUpdate,
      "updateByUserID": updateByUserID,
      "customer": customer,
      "dateTimeIs": dateTimeIs,
      "noteIs": noteIs,
      "phone": phone,
    };
  }
}

class RowEditNote {
  String key;
  bool needUpdate;
  int updateByUserID;
  String noteIs;

  RowEditNote(this.noteIs) {
    needUpdate = true;
    updateByUserID = int.parse(controlUser.drNow.documentID);
  }

  toJson() {
    return {
      "needUpdate": needUpdate,
      "updateByUserID": updateByUserID,
      "noteIs": noteIs,
    };
  }
}
