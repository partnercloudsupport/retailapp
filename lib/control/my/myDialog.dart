import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myClipper.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';

enum ReturnDialog { no, yes, cancel, ok, news }

Widget _title(String title) {
  return Directionality(
    textDirection: MyLanguage.rtl(),
    child: ClipPath(
      clipper: MyClipper1(),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 100,
        color: MyColor.color1,
        child: Text(title, style: MyStyle.style20Color2()),
      ),
    ),
  );
}

Widget _description(String description) {
  return Column(
    children: <Widget>[
      Text(
        description,
        style: MyStyle.style18Color1(),
      ),
      SizedBox(
        height: 40,
      ),
      SizedBox(
        height: 2,
        child: Container(
          color: MyColor.color1,
        ),
      )
    ],
  );
}

Widget itemAction(
    BuildContext context, String text, ReturnDialog returnDialog) {
  return SimpleDialogOption(
    onPressed: () => Navigator.pop(context, returnDialog),
    child: Container(
      child: Text(text, style: MyStyle.style16Color1Italic()),
      decoration: BoxDecoration(
          color: MyColor.color1.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 21),
    ),
  );
}

Future<ReturnDialog> show(BuildContext context, String title,
    String description, List<Widget> action) async {
  Widget sd = SimpleDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: _title(title),
    titlePadding: EdgeInsets.only(left: 20, right: 20),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    children: <Widget>[
      _description(description),
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end,
          children: action,
        ),
      )
    ],
  ).build(context);

  ReturnDialog returnDialog =
      await showDialog(context: context, builder: (BuildContext bc) => sd);

  return returnDialog == null ? ReturnDialog.cancel : returnDialog;
}

Future<ReturnDialog> deleteAsk(BuildContext context) async {
  return await show(
    context,
    MyLanguage.text(myLanguageItem.delete),
    MyLanguage.text(myLanguageItem.areYouSureYouWantToDelete),
    [
      itemAction(
          context, MyLanguage.text(myLanguageItem.yes), ReturnDialog.yes),
      Spacer(),
      itemAction(context, MyLanguage.text(myLanguageItem.no), ReturnDialog.no),
    ],
  );
}
