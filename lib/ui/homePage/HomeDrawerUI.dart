import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/mySharedPreferences.dart';
import 'package:retailapp/ui/user/userLoginUI.dart' as userLoginUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class HomeDrawerUI {
  static Widget buildDrawer(BuildContext bc) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Smart Security',
              style: MyStyle.style20Color2(),
            ),
            accountEmail: Text(controlUser.drNow.data['name'],
                style: MyStyle.style16Color2()),
            currentAccountPicture: Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        controlUser.drNow.data['imageURL'].toString(),
                      ))),
            ),
          ),
          ListTile(
            title: Text('Language EN', style: MyStyle.style16Color1()),
            onTap: () {
              MyLanguage.setLanguageEN();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Language AR', style: MyStyle.style16Color1()),
            onTap: () {
              MyLanguage.setLanguageAR();
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.exit_to_app),
            title: Text('Logout', style: MyStyle.style16Color1()),
            onTap: () {
              MySharedPreferences.setUserPassword('');
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
}
