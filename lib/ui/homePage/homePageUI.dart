import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/ui/callerLog/callerLogListUI.dart' as callerLogListUI;
import 'package:retailapp/ui/customer/customerListUI.dart' as customerListUI;
import 'package:retailapp/ui/request/requestListUI.dart' as requestListUI;
import 'package:retailapp/ui/myDiary/myDiaryListUI.dart' as myDiaryListUI;
import 'package:retailapp/control/my/myLanguage.dart';

import 'package:retailapp/ui/reports/reportsRequestMyDiaryUI.dart'
    as reportsRequestMyDiaryUI;

int _currentIndex = 1;

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class UI extends StatefulWidget {
  UI(_currentIndex);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Widget _ui = callerLogListUI.UI();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
    _openUI(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: _ui,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (int i) => _openUI(i),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts,
            ),
            title: Text(MyLanguage.text(myLanguageItem.contacts))),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_from_queue,
            ),
            title: Text(MyLanguage.text(myLanguageItem.requests))),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
            ),
            title: Text(MyLanguage.text(myLanguageItem.callerLog))),
        BottomNavigationBarItem(
            activeIcon: _buildIconMyDiary(true),
            icon: _buildIconMyDiary(false),
            title: Text(MyLanguage.text(myLanguageItem.myDiaries))),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.pie_chart,
            ),
            title: Text(MyLanguage.text(myLanguageItem.reports))),
      ],
    );
  }

  Widget _buildIconMyDiary(bool activeIcon) {
    return Image.asset(
      'lib/res/image/My_Diary_001_32.png',
      color: activeIcon ? MyColor.color1 : MyColor.grey,
      height: 24,
      width: 24,
    );
  }

  void _openUI(int i) {
    setState(() {
      _currentIndex = i;

      switch (_currentIndex) {
        case 0:
          _ui = customerListUI.UI();
          break;
        case 1:
          _ui = requestListUI.UI();
          break;
        case 2:
          _ui = callerLogListUI.UI();
          break;
        case 3:
          _ui = myDiaryListUI.UI();
          break;
        case 4:
          _ui = reportsRequestMyDiaryUI.UI();
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
