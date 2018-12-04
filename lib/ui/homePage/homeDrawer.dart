import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Samer Brees',
              style: myStyle.mainTitle2(),
            ),
            accountEmail: Text('sa@sa.com', style: myStyle.mainTitle2()),
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.verified_user,
                color: myColor.master,
              ),
              backgroundColor: Colors.white,
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
        ],
      ),
    );
  }
