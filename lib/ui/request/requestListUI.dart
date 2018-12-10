import 'package:flutter/material.dart';
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/request/requestListTabUI.dart' as requestListTabUI;
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
            requestListTabUI.UI(controlRequest.getToday(), 0,3),
            requestListTabUI.UI(controlRequest.getTomorrow(), 0,3),
            requestListTabUI.UI(controlRequest.getAll(), 0,3),
            requestListTabUI.UI(controlRequest.getPending(), 1,0),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.TextIndex.requests)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: myLanguage.text(myLanguage.TextIndex.today),
          ),
          Tab(
            text: myLanguage.text(myLanguage.TextIndex.tomorrow),
          ),
          Tab(
            text: myLanguage.text(myLanguage.TextIndex.all),
          ),
          Tab(
            text: myLanguage.text(myLanguage.TextIndex.pending),
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
