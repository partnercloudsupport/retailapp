import 'package:flutter/material.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/myDiary/myDiaryListTabUI.dart';
import 'package:retailapp/ui/homePage/homeDrawerUI.dart';
import 'package:retailapp/ui/all/selectWithFilterUI.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class MyDiaryListUI extends StatefulWidget {
  @override
  MyDiaryListUIState createState() => MyDiaryListUIState();
}

class MyDiaryListUIState extends State<MyDiaryListUI>
    with SingleTickerProviderStateMixin {
  bool _searchActive = false;
  String _searchText = '';
  String _filterByUser = '';

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
            MyDiaryListTabUI(
              controlMyDiary.TypeView.today,
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: _filterByUser,
            ),
            MyDiaryListTabUI(
              controlMyDiary.TypeView.yesterday,
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: _filterByUser,
            ),
            MyDiaryListTabUI(
              controlMyDiary.TypeView.lastWeek,
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: _filterByUser,
            ),
            MyDiaryListTabUI(
              controlMyDiary.TypeView.all,
              _searchActive,
              _searchText,
              _searchSetText,
              filterByUesr: _filterByUser,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.myDiaries)),
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
            text: MyLanguage.text(myLanguageItem.all),
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
        color: _filterByUser.isNotEmpty ? Colors.white : Colors.grey,
        size: _filterByUser.isNotEmpty ? 32 : null,
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
            builder: (context) => SelectWithFilterUI(
                  controlUser.getAllOrderByName(),
                  _filterApply,
                  MyLanguage.text(myLanguageItem.chooseAUser),
                  autofocus: false,
                )));
  }

  void _filterApply(String filterByUser) {
    setState(() {
      _filterByUser = filterByUser.toLowerCase();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
