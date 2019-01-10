import 'package:flutter/material.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/myDiary/myDiaryListTabUI.dart' as myDiaryListTabUI;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/ui/all/selectWithFilterUI.dart' as selectWithFilterUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

String filterByUser = '';

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _searchActive = false;
  String _searchText = '';

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
            myDiaryListTabUI.UI(
              controlMyDiary.getToday(),
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: filterByUser,
            ),
            myDiaryListTabUI.UI(
              controlMyDiary.getYesterday(),
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: filterByUser,
            ),
            myDiaryListTabUI.UI(
              controlMyDiary.getLastWeek(),
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: filterByUser,
            ),
            myDiaryListTabUI.UI(
              controlMyDiary.getAll(),
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: filterByUser,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.myDiaries)),
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
            text: myLanguage.text(myLanguage.item.all),
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
        color: filterByUser.isNotEmpty ? Colors.white : Colors.grey,
        size: filterByUser.isNotEmpty ? 32 : null,
      ),
      onPressed: _filterOpen,
    );
  }

  void _searchReactive() {
    setState(() {
      _searchActive = !_searchActive;
      _searchText = _searchText;
    });
  }

  void _searchSetText(String v) {
    setState(() {
      _searchText = v;
    });
  }

  void _filterOpen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlUser.getAll(),
                  _filterApply,
                  myLanguage.text(myLanguage.item.chooseAnEmployee),
                  autofocus: false,
                )));
  }

  void _filterApply(String _filterByUser) {
    setState(() {
      filterByUser = _filterByUser.toLowerCase();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
