import 'package:flutter/material.dart';
import 'package:retailapp/control/CallerLog/controlCallerLog.dart'
    as controlCallerLog;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/callerLog/callerLogListTabUI.dart';
import 'package:retailapp/ui/homePage/homeDrawerUI.dart';

class CallerLogListUI extends StatefulWidget {
  @override
  CallerLogListUIState createState() => CallerLogListUIState();
}

class CallerLogListUIState extends State<CallerLogListUI> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        drawer: HomeDrawerUI.buildDrawer(context),
        appBar: _buildAppBar(),
        resizeToAvoidBottomPadding: false,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CallerLogListTabUI(controlCallerLog.getToday()),
            CallerLogListTabUI(controlCallerLog.getYesterday()),
            CallerLogListTabUI(controlCallerLog.getLastWeek()),
            CallerLogListTabUI(
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
      title: Text(MyLanguage.text(myLanguageItem.callerLog)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: MyLanguage.text(myLanguageItem.today),
          ),
          Tab(
            text: MyLanguage.text(myLanguageItem.yesterday),
          ),
          Tab(
            text: MyLanguage.text(myLanguageItem.lastWeek),
          ),
          Tab(
            text: MyLanguage.text(myLanguageItem.interval),
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
