import 'package:flutter/material.dart';
import 'package:retailapp/control/CallerLog/controlCallerLog.dart'
    as controlCallerLog;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/callerLog/callerLogListTabUI.dart'
    as callerLogListTabUI;
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
            callerLogListTabUI.UI(controlCallerLog.getToday()),
            callerLogListTabUI.UI(controlCallerLog.getYesterday()),
            callerLogListTabUI.UI(controlCallerLog.getLastWeek()),
            callerLogListTabUI.UI(
              null,
              withFilterAction: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.callerLog)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: myLanguage.text(myLanguage.item.today),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.yesterday),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.lastWeek),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.interval),
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
