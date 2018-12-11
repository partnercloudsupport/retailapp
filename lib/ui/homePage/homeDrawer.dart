import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;
import 'package:retailapp/ui/user/userLoginUI.dart' as userLoginUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myString.dart' as myString;

Widget buildDrawer(BuildContext bc) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            'Smart Security',
            style: myStyle.style20Color2(),
          ),
          accountEmail: Text(
              controlUser.drNow.data['name'] +
                  ' ' +
                  myString
                      .betweenBrackets(controlUser.drNow.data['permission']),
              style: myStyle.style16Color2()),
          currentAccountPicture: Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        controlUser.drNow.data['imageURL'].toString()))),
          ),
        ),
        ListTile(
          title: Text('Language EN', style: myStyle.style16()),
          onTap: () {
            myLanguage.setLanguageEN();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Language AR', style: myStyle.style16()),
          onTap: () {
            myLanguage.setLanguageAR();
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.exit_to_app),
          title: Text('Logout', style: myStyle.style16()),
          onTap: () {
            mySharedPreferences.setUserPassword('');
            Navigator.pushAndRemoveUntil(
                bc,
                MaterialPageRoute(builder: (context) => userLoginUI.UI()),
                ModalRoute.withName(''));
          },
        ),
      ],
    ),
  );
}
