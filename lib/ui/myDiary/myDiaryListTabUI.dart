import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/ui/myDiary/myDiaryEditUI.dart';
import 'package:retailapp/ui/GoogleMap/GoogleMapViewUI.dart';
import 'package:retailapp/ui/myDiary/myDiaryNewUI.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/mySuperTooltip.dart';
import 'package:retailapp/ui/request/requestNewUI.dart' as requestNewUI;
import 'package:retailapp/control/my/myDialog.dart' as myDialog;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;

class MyDiaryListTabUI extends StatefulWidget {
  final controlMyDiary.TypeView _typeView;
  final bool _searchActive;
  final String _searchText;
  final void Function(String) _searchSetText;
  final String filterByUesr;

  MyDiaryListTabUI(
      this._typeView, this._searchActive, this._searchText, this._searchSetText,
      {this.filterByUesr = ''});
  @override
  MyDiaryListTabUIState createState() => MyDiaryListTabUIState(_searchText);
}

class MyDiaryListTabUIState extends State<MyDiaryListTabUI>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searchActive = false;
  String _searchText;
  TextEditingController _searchController;
  AnimationController _ac;
  String _followUpUserMyDiary = controlUser.drNow.data['name'] +
      ', ' +
      controlUser.drNow.data['followUpUserMyDiary'].toString().toLowerCase() +
      ', ';
  MyDiaryListTabUIState(this._searchText);

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    _searchController = TextEditingController(text: _searchText);
    _ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    setState(() {
      _followUpUserMyDiary = controlUser.drNow.data['name'] +
          ', ' +
          controlUser.drNow.data['followUpUserMyDiary']
              .toString()
              .toLowerCase() +
          ', ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          _buildSearch(),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSearch() {
    return widget._searchActive
        ? Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: MyColor.color1))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          autofocus: true,
                          style: MyStyle.style15Color1(),
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                MyLanguage.text(myLanguageItem.search) + '...',
                          ),
                          onChanged: _searchApply,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _searchText.isEmpty == true
                          ? SizedBox(width: 0)
                          : InkWell(
                              child: Icon(
                                Icons.clear,
                                color: MyColor.color1,
                              ),
                              onTap: _searchClear,
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 1,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: MyColor.color1,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 5.0)),
                  ])),
            ],
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlMyDiary.getAllOrderByUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return ListView(
          padding: EdgeInsets.only(bottom: 70),
          children: v.data.documents.where((v) {
            return _cardValid(v);
          }).map((DocumentSnapshot dr) {
            return _buildCard(dr);
          }).toList(),
        );
      },
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return ExpansionTile(
      leading: Text(
        dr['amountF'],
      ),
      title: Text(
        dr['customer'],
        style: MyStyle.style20Color1(),
      ),
      trailing: controlUser.drNow.data['name'] != dr['user']
          ? Text(
              dr['user'],
            )
          : null,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dr.data['note'],
                  style: MyStyle.style16Color1Italic(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    color: MyColor.grey,
                  ),
                  Text(dr['durationHourF'],
                      style: MyStyle.style12Color3Italic()),
                ],
              ),
            ),
            controlMyDiary.buildType(dr['typeIs'], MyColor.grey),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildViewMapButton(dr),
                  _buildNewRequest(dr),
                  _buildEditButton(dr),
                  _buildNeedInsertOrUpdate(dr),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildNewRequest(DocumentSnapshot dr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Request',
              style: MyStyle.style14Color1(),
            ),
            Icon(
              Icons.add,
              color: MyColor.color1,
            ),
          ],
        ),
        onTap: () => _newRequest(dr['customer'], dr['note'], dr['amount']),
      ),
    );
  }

  Widget _buildViewMapButton(DocumentSnapshot dr) {
    return controlUser.drNow.data['name'].toString().toLowerCase() == 'admin'
        ? IconButton(
            icon: Icon(
              Icons.location_on,
              color: MyColor.color1,
            ),
            onPressed: () => _viewMap(dr),
          )
        : SizedBox();
  }

  Widget _buildEditButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: MyColor.color1,
      ),
      onPressed: () => _edit(dr),
    );
  }

  Widget _buildNeedInsertOrUpdate(DocumentSnapshot dr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        dr['needInsert'] == false ? SizedBox() : _buildNeedAction(Icons.add),
        dr['needUpdate'] == false ? SizedBox() : _buildNeedAction(Icons.update),
        dr['needDelete'] == false ? SizedBox() : _buildNeedAction(Icons.update),
        _buildDelete(dr),
      ],
    );
  }

  Widget _buildNeedAction(IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Icon(
        icon,
        color: Colors.red,
      ),
    );
  }

  Widget _buildDelete(DocumentSnapshot dr) {
    return InkWell(
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 5.0),
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      onTap: _deleteTooltip,
      onLongPress: () => _delete(dr),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      child: Icon(Icons.add),
      onPressed: _new,
      backgroundColor: MyColor.color1,
    );
  }

  bool _cardValid(DocumentSnapshot dr) {
    int dateNumber = MyDateTime.castDateToInt(dr['beginDate']);

    switch (widget._typeView) {
      case controlMyDiary.TypeView.today:
        if (dateNumber != MyDateTime.castDateNowToInt()) return false;
        break;
      case controlMyDiary.TypeView.yesterday:
        if (dateNumber != MyDateTime.castDateNowToInt(addNumber: -1))
          return false;
        break;
      case controlMyDiary.TypeView.lastWeek:
        if (dateNumber <= MyDateTime.castDateNowToInt(addNumber: -9) ||
            dateNumber >= MyDateTime.castDateNowToInt(addNumber: -1))
          return false;
        break;
      default:
    }

    bool followUpUserMyDiary = (_followUpUserMyDiary
            .contains(dr['user'].toString().toLowerCase() + ',') ||
        controlUser.drNow.data['name'].toString().toLowerCase() == 'admin');

    if (followUpUserMyDiary == false) return false;

    return (dr['customer'] + dr['note'] + dr['user'])
            .toLowerCase()
            .contains(_searchText) &&
        (widget.filterByUesr.isEmpty
            ? followUpUserMyDiary
            : (dr['user']
                    .toString()
                    .toLowerCase()
                    .contains(widget.filterByUesr) &&
                followUpUserMyDiary));
  }

  void _searchApply(String v) {
    setState(() {
      _searchText = v;
    });
    widget._searchSetText(v);
  }

  void _searchClear() {
    setState(() {
      _searchText = '';
      _searchController = TextEditingController(text: '');
      widget._searchSetText('');
    });
  }

  void _new() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDiaryNewUI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyDiaryEditUI(dr)));
  }

  void _viewMap(DocumentSnapshot dr) async {
    DocumentSnapshot drCustomer =
        await controlCustomer.getDataRow(dr.data['customerID'].toString());
    if (drCustomer.exists == false) {
      MySnackBar.showInHomePage1(
          MyLanguage.text(myLanguageItem.theCustomerYouWantIsNotFound));
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => GoogleMapViewUI(
                drCustomer.data['name'],
                drCustomer.data['note'],
                drCustomer.data['mapLocation'])));
  }

  void _deleteTooltip() {
    MySuperTooltip.show4(
        context, MyLanguage.text(myLanguageItem.pressForALongTimeToDeleteIt));
  }

  void _delete(DocumentSnapshot dr) async {
    if (await myDialog.deleteAsk(context) == myDialog.ReturnDialog.yes) {
      controlMyDiary.delete(scaffoldKey, dr.documentID);
    }
  }

  void _newRequest(
      String customer, String requiredImplementation, double targetPrice) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => requestNewUI.RequestNewUI(
                  customer,
                  requiredImplementation,
                  targetPrice,
                )));
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _searchController.dispose();
  }
}
