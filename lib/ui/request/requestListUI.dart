import 'package:flutter/material.dart';
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/request/requestListTabUI.dart' as requestListTabUI;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/ui/request/requestFilterUI.dart' as requestFilterUI;

String _filterByType = '';
String _filterByEmployee = '';

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _searchActive = false;

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
            requestListTabUI.UI(
              controlRequest.getToday(),
              0,
              3,
              _searchActive,
              filterByType: _filterByType,
              filterByEmployee: _filterByEmployee,
            ),
            requestListTabUI.UI(
              controlRequest.getTomorrow(),
              0,
              3,
              _searchActive,
              filterByType: _filterByType,
              filterByEmployee: _filterByEmployee,
            ),
            requestListTabUI.UI(
              controlRequest.getAll(),
              0,
              3,
              _searchActive,
              filterByType: _filterByType,
              filterByEmployee: _filterByEmployee,
            ),
            requestListTabUI.UI(
              controlRequest.getPending(),
              1,
              0,
              _searchActive,
              filterByType: _filterByType,
              filterByEmployee: _filterByEmployee,
            ),
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
      actions: <Widget>[
        _buildSeach(),
        _buildFilter(),
      ],
    );
  }

  Widget _buildSeach() {
    return IconButton(
      icon: Icon(
        Icons.search,
        color: _searchActive ? Colors.white : Colors.grey,
        size: _searchActive ? 32 : null,
      ),
      onPressed: _searchReactive,
    );
  }

  Widget _buildFilter() {
    return IconButton(
      icon: Icon(
        Icons.filter_list,
        color: _filterByType.isNotEmpty || _filterByEmployee.isNotEmpty
            ? Colors.white
            : Colors.grey,
        size: _filterByType.isNotEmpty || _filterByEmployee.isNotEmpty
            ? 32
            : null,
      ),
      onPressed: _filterOpen,
    );
  }

  void _searchReactive() {
    setState(() {
      _searchActive = !_searchActive;
    });
  }

  void _filterOpen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => requestFilterUI.UI(
                _filterApply, _filterByEmployee, _filterByType)));
  }

  void _filterApply(String filterByType, String filterByEmployee) {
    setState(() {
      _filterByType = filterByType;
      _filterByEmployee = filterByEmployee;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
