import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/employee/employeeRequestReportTabUI.dart'
    as employeeRequestReportTabUI;
import 'package:retailapp/ui/user/userMyDiaryReportTabUI.dart'
    as userMyDiaryReportTabUI;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/ui/employee/employeeRequestReportFilterUI.dart'
    as employeeRequestReportFilterUI;
import 'package:retailapp/ui/user/userMyDiaryReportFilterUI.dart'
    as userMyDiaryReportFilterUI;


String _filterEmployee = '';
String _filterUser = '';
bool _filterWithDate = false;
DateTime _filterFromDate = DateTime.now();
DateTime _filterToDate = DateTime.now();
bool _filterWithTotalZero = true;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        drawer: homeDrawer.buildDrawer(context),
        appBar: _buildAppBar(),
        resizeToAvoidBottomPadding: false,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            employeeRequestReportTabUI.UI(_filterEmployee, _filterWithDate,
                _filterFromDate, _filterToDate, _filterWithTotalZero),
            userMyDiaryReportTabUI.UI(_filterUser, _filterWithDate,
                _filterFromDate, _filterToDate, _filterWithTotalZero),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.reports)),
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            text: MyLanguage.text(myLanguageItem.requests),
          ),
          Tab(
            text: MyLanguage.text(myLanguageItem.myDiaries),
          ),
        ],
      ),
      actions: <Widget>[_buildFilter()],
    );
  }

  Widget _buildFilter() {
    bool b = (_filterEmployee.isNotEmpty ||
        _filterUser.isNotEmpty ||
        _filterWithDate ||
        _filterWithTotalZero == false);

    return IconButton(
      icon: Icon(
        Icons.filter_list,
        color: b ? Colors.white : Colors.grey,
        size: b ? 32 : null,
      ),
      onPressed: _filterOpen,
    );
  }

  void _filterOpen() {
    if (_tabController.index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => employeeRequestReportFilterUI.UI(
                  _filterEmployeeApply,
                  _filterEmployee,
                  _filterWithDate,
                  _filterFromDate,
                  _filterToDate,
                  _filterWithTotalZero)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => userMyDiaryReportFilterUI.UI(
                  _filterUserApply,
                  _filterUser,
                  _filterWithDate,
                  _filterFromDate,
                  _filterToDate,
                  _filterWithTotalZero)));
    }
  }

  void _filterEmployeeApply(
      String filterEmployee,
      bool filterWithDate,
      DateTime filterFromDate,
      DateTime filterToDate,
      bool filterWithTotalZero) {
    setState(() {
      _filterEmployee = filterEmployee;
      _filterWithDate = filterWithDate;
      DateTime fixDate = filterFromDate;
      _filterFromDate = MyDateTime.getLess(fixDate, filterToDate);
      _filterToDate = MyDateTime.getBiggest(fixDate, filterToDate);
      _filterWithTotalZero = filterWithTotalZero;
    });
  }

  void _filterUserApply(
      String filterUser,
      bool filterWithDate,
      DateTime filterFromDate,
      DateTime filterToDate,
      bool filterWithTotalZero) {
    setState(() {
      _filterUser = filterUser;
      _filterWithDate = filterWithDate;
      DateTime fixDate = filterFromDate;
      _filterFromDate = MyDateTime.getLess(fixDate, filterToDate);
      _filterToDate = MyDateTime.getBiggest(fixDate, filterToDate);
      _filterWithTotalZero = filterWithTotalZero;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
