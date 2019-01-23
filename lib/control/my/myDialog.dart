import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myColor.dart' as myColor;

class Fffff extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final Path p = Path();

    p.lineTo(0, s.height);

    p.quadraticBezierTo(
        s.width * .25, s.height - 50, s.width * .5, s.height - 35);

    p.quadraticBezierTo(s.width * .75, s.height - 20, s.width, s.height - 50);

    p.lineTo(s.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Future<String> deleteAskffff(BuildContext context) async {
  var sd = SimpleDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Directionality(
      textDirection: myLanguage.rtl(),
      child: ClipPath(
        clipper: Fffff(),
        child: Container(
          padding: EdgeInsets.all(20),
          height: 100,
          color: myColor.color1,
          child: Text(myLanguage.text(myLanguage.item.delete),
              style: myStyle.style20Color2()),
        ),
      ),
    ),
    titlePadding: EdgeInsets.only(left: 20, right: 20),
    contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
    children: <Widget>[
      Center(
        child: Text(
          myLanguage.text(myLanguage.item.areYouSureYouWantToDelete),
          style: myStyle.style18Color1(),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      SizedBox(
        height: 2,
        child: Container(
          color: myColor.color1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            SimpleDialogOption(
              child: Text(myLanguage.text(myLanguage.item.no),
                  style: myStyle.style16Color1Italic()),
              onPressed: () => Navigator.pop(context, 'No'),
            ),
            Expanded(
              child: Text(''),
            ),
            SimpleDialogOption(
              child: Text(myLanguage.text(myLanguage.item.yes),
                  style: myStyle.style16Color4()),
              onPressed: () => Navigator.pop(context, 'Yes'),
            ),
          ],
        ),
      )
    ],
  ).build(context);

  return await showDialog(context: context, builder: (BuildContext bc) => sd);
}

Future<String> deleteAsk(BuildContext context) async {
  var sd = SimpleDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Directionality(
      textDirection: myLanguage.rtl(),
      child: Text(myLanguage.text(myLanguage.item.delete),
          style: myStyle.style20Color4()),
    ),
    titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
    contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
    children: <Widget>[
      Center(
        child: Text(
          myLanguage.text(myLanguage.item.areYouSureYouWantToDelete),
          style: myStyle.style18Color1(),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      SizedBox(
        height: 2,
        child: Container(
          color: myColor.color1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            SimpleDialogOption(
              child: Text(myLanguage.text(myLanguage.item.no),
                  style: myStyle.style16Color1Italic()),
              onPressed: () => Navigator.pop(context, 'No'),
            ),
            Expanded(
              child: Text(''),
            ),
            SimpleDialogOption(
              child: Text(myLanguage.text(myLanguage.item.yes),
                  style: myStyle.style16Color4()),
              onPressed: () => Navigator.pop(context, 'Yes'),
            ),
          ],
        ),
      )
    ],
  ).build(context);

  return await showDialog(context: context, builder: (BuildContext bc) => sd);
}
