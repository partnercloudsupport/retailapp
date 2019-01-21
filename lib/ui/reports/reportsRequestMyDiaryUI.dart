import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/employee/employeeRequestReportTabUI.dart'
    as employeeRequestReportTabUI;
import 'package:retailapp/ui/user/userMyDiaryReportTabUI.dart'
    as userMyDiaryReportTabUI;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        drawer: homeDrawer.buildDrawer(context),
        appBar: _buildAppBar(),
        resizeToAvoidBottomPadding: false,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            employeeRequestReportTabUI.UI(),
            userMyDiaryReportTabUI.UI(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.reports)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: myLanguage.text(myLanguage.item.requests),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.myDiaries),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
