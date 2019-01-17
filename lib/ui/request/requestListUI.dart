import 'dart:async';

import 'package:flutter/material.dart';
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/request/requestListTabUI.dart' as requestListTabUI;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/ui/request/requestFilterUI.dart' as requestFilterUI;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:connectivity/connectivity.dart';
import 'package:retailapp/control/my/mySuperTooltip.dart' as mySuperTooltip;

String _filterType = '';
String filterEmployee = '';
bool _filterWithDate = false;
DateTime _filterFromDate = DateTime.now();
DateTime _filterToDate = DateTime.now();
ConnectivityResult _connectionStatus = ConnectivityResult.none;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _searchActive = false;
  TabController _tabController;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);

    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  Future<Null> _initConnectivity() async {
    ConnectivityResult connectionStatus;
    try {
      connectionStatus = await _connectivity.checkConnectivity();
    } catch (e) {
      connectionStatus = ConnectivityResult.none;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
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
                _searchActive,
                controlRequest.TypeView.today,
                _filterType,
                filterEmployee,
                _filterWithDate,
                _filterFromDate,
                _filterToDate,
                _connectionStatus),
            requestListTabUI.UI(
                _searchActive,
                controlRequest.TypeView.tomorrow,
                _filterType,
                filterEmployee,
                _filterWithDate,
                _filterFromDate,
                _filterToDate,
                _connectionStatus),
            requestListTabUI.UI(
                _searchActive,
                controlRequest.TypeView.all,
                _filterType,
                filterEmployee,
                _filterWithDate,
                _filterFromDate,
                _filterToDate,
                _connectionStatus),
            requestListTabUI.UI(
                _searchActive,
                controlRequest.TypeView.pending,
                _filterType,
                filterEmployee,
                _filterWithDate,
                _filterFromDate,
                _filterToDate,
                _connectionStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.requests)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: myLanguage.text(myLanguage.item.today),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.tomorrow),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.all),
          ),
          Tab(
            text: myLanguage.text(myLanguage.item.pending),
          ),
        ],
      ),
      actions: <Widget>[
        _buildInternetStatus(),
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
    bool b = (_filterType.isNotEmpty ||
        filterEmployee.isNotEmpty ||
        _filterWithDate);

    return IconButton(
      icon: Icon(
        Icons.filter_list,
        color: b ? Colors.white : Colors.grey,
        size: b ? 32 : null,
      ),
      onPressed: _filterOpen,
    );
  }

  Widget _buildInternetStatus() {
    return _connectionStatus == ConnectivityResult.none
        ? IconButton(
            icon: Icon(
              Icons.warning,
              color: Colors.red,
            ),
            onPressed: _internetStatusTooltip,
          )
        : SizedBox();
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
                _filterApply,
                _filterType,
                filterEmployee,
                _filterWithDate,
                _filterFromDate,
                _filterToDate)));
  }

  void _filterApply(String filterType, String _filterEmployee,
      bool filterWithDate, DateTime filterFromDate, DateTime filterToDate) {
    setState(() {
      _filterType = filterType;
      filterEmployee = _filterEmployee;
      _filterWithDate = filterWithDate;
      DateTime fixDate = filterFromDate;
      _filterFromDate = myDateTime.getLess(fixDate, filterToDate);
      _filterToDate = myDateTime.getBiggest(fixDate, filterToDate);
    });
  }

  void _internetStatusTooltip() {
    mySuperTooltip.show4(
        context,
        myLanguage.text(myLanguage.item.youAreNotConnectedToTheInternet) +
            '\n\n 1-' +
            myLanguage
                .text(myLanguage.item.youWereUnableToAddOrEditAnyRequest) +
            '\n 2-' +
            myLanguage.text(myLanguage.item.currentDataMayHaveBeenChanged));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
