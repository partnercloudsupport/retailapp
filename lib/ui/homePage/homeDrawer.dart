import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;
import 'package:retailapp/ui/user/userLoginUI.dart' as userLoginUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

Widget buildDrawer(BuildContext bc) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            'Samer Brees',
            style: myStyle.mainTitle2(),
          ),
          accountEmail: Text(
              controlUser.drNow.data['name'].toString() +
                  ' (' +
                  controlUser.drNow.data['permission'].toString() +
                  ')',
              style: myStyle.mainTitle2()),
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
          title: Text('Language EN', style: myStyle.mainTitle()),
          onTap: () {
            myLanguage.setLanguageEN();
          },
        ),
        Divider(),
        ListTile(
          title: Text('Language AR', style: myStyle.mainTitle()),
          onTap: () {
            myLanguage.setLanguageAR();
          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.exit_to_app),
          title: Text('Logout', style: myStyle.mainTitle()),
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