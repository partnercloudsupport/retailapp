import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/request/requestNewUI.dart' as requestNewUI;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/request/requestNoteListUI.dart'
    as requestNoteListUI;
import 'package:retailapp/ui/request/requestEditUI.dart' as requestEditUI;
import 'package:retailapp/control/my/myString.dart' as myString;
import 'package:retailapp/ui/request/requestWinUI.dart' as requestWinUI;
import 'package:retailapp/ui/request/requestImageListUI.dart'
    as requestImageListUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/ui/mapGoogle/mapGoogleViewUI.dart' as mapGoogleViewUI;
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/ui/mapBox/mapBoxSelectUI.dart' as mapBoxSelectUI;
import 'package:retailapp/ui/homePage/homePageUI.dart' as homePageUI;
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;

class UI extends StatefulWidget {
  final bool _searchActive;
  final controlRequest.TypeView _typeView;
  final String filterType;
  final String filterEmployee;
  final bool filterWithDate;
  final DateTime filterFromDate;
  final DateTime filterToDate;

  UI(this._searchActive, this._typeView, this.filterType, this.filterEmployee,
      this.filterWithDate, this.filterFromDate, this.filterToDate);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _followUpEmployeeRequest = controlUser
          .drNow.data['followUpEmployeeRequest']
          .toString()
          .toLowerCase() +
      ', ';

  String _search = '';
  TextEditingController _searchController = TextEditingController(text: '');
  int _dateTodayNumber = myDateTime.castDateNowToInt();
  int _dateTomorrowNumber = myDateTime.castDateNowToInt(addNumber: 1);
  int dateFilterNumberFrom = 0;
  int dateFilterNumberTo = 0;

  @override
  void initState() {
    super.initState();
    controlUser.getMe();

    setState(() {
      _followUpEmployeeRequest = controlUser
              .drNow.data['followUpEmployeeRequest']
              .toString()
              .toLowerCase() +
          ', ';
    });
    dateFilterNumberFrom = myDateTime.castDateToInt(widget.filterFromDate);
    dateFilterNumberTo = myDateTime.castDateToInt(widget.filterToDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        bottom: BorderSide(width: 1.0, color: myColor.color1))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          autofocus: true,
                          style: myStyle.style15Color1(),
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                myLanguage.text(myLanguage.item.search) + '...',
                          ),
                          onChanged: _searchApply,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _search.isEmpty == true
                          ? SizedBox(width: 0)
                          : InkWell(
                              child: Icon(
                                Icons.clear,
                                color: myColor.color1,
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
                        color: myColor.color1,
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
      stream: controlRequest.getAllOrderByEmployee(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildLoading();
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

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpansionTile(
            leading: Text(dr['employee']),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dr['customer'],
                style: myStyle.style16Color1Italic(),
              ),
            ),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dr['requiredImplementation'],
                        style: myStyle.style16Color1Italic()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dr['typeIs']),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                    child: Text(
                      myDateTime.formatAndShortByFromString(
                          dr['appointment'].toString(),
                          myDateTime.Types.ddMMyyyyhhmma),
                      textAlign: TextAlign.end,
                      style: myStyle.style12Color3(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        _buildNote(dr),
                        _buildImage(dr),
                        _buildViewMap(dr),
                        _buildEditMap(dr),
                        _buildWin(dr),
                        _buildEdit(dr),
                        _buildNeedInsertOrUpdate(dr)
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNote(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.note_add,
            color: myColor.color1,
          ),
          Text(
            myLanguage.text(myLanguage.item.notes) +
                (dr['notesCount'] == 0
                    ? ''
                    : ' ' +
                        myString.betweenBrackets(dr['notesCount'].toString())),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => requestNoteListUI
                  .UI(double.parse(dr.documentID.toString())))),
    );
  }

  Widget _buildImage(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.image,
            color: myColor.color1,
          ),
          Text(
            myLanguage.text(myLanguage.item.images) +
                (dr['imageCount'] == 0
                    ? ''
                    : ' ' +
                        myString.betweenBrackets(dr['imageCount'].toString())),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => _imageZoom(dr),
    );
  }

  Widget _buildViewMap(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: myColor.color1,
          ),
          Text(
            myLanguage.text(myLanguage.item.view),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => _viewMap(dr),
    );
  }

  Widget _buildEditMap(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: myColor.color1,
          ),
          Text(
            myLanguage.text(myLanguage.item.edit),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => _editMap(dr),
    );
  }

  Widget _buildWin(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.asset(
            'lib/res/image/Win_001_32.png',
            color: myColor.color1,
            width: 24,
            height: 24,
          ),
          Text(
            myLanguage.text(myLanguage.item.win),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => _win(dr),
    );
  }

  Widget _buildEdit(DocumentSnapshot dr) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.edit,
            color: myColor.color1,
          ),
          Text(
            myLanguage.text(myLanguage.item.edit),
            style: myStyle.style14Color1(),
          ),
        ],
      ),
      onTap: () => _edit(dr),
    );
  }

  Widget _buildNeedInsertOrUpdate(DocumentSnapshot dr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        dr['needInsert']
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.add,
                  color: Colors.red,
                ),
              )
            : SizedBox(),
        dr['needUpdate']
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.update,
                  color: Colors.red,
                ),
              )
            : SizedBox()
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      child: Icon(Icons.add),
      onPressed: _new,
      backgroundColor: myColor.color1,
    );
  }

  bool _cardValid(DocumentSnapshot dr) {
    int dateNumber = myDateTime.castDateToInt(dr['appointment']);

    switch (widget._typeView) {
      case controlRequest.TypeView.today:
        if (dateNumber != _dateTodayNumber ||
            dr['statusIs'] == 1 ||
            dr['stageIs'] < 3) return false;
        break;
      case controlRequest.TypeView.tomorrow:
        if (dateNumber != _dateTomorrowNumber ||
            dr['statusIs'] == 1 ||
            dr['stageIs'] < 3) return false;
        break;
      case controlRequest.TypeView.all:
        if (dr['statusIs'] == 1 || dr['stageIs'] < 3) return false;
        if (widget.filterWithDate) {
          if (dateNumber < dateFilterNumberFrom ||
              dateNumber > dateFilterNumberTo) return false;
        }

        break;
      case controlRequest.TypeView.pending:
        if (dr['statusIs'] != 1) return false;

        if (widget.filterWithDate) {
          if (dateNumber < dateFilterNumberFrom ||
              dateNumber > dateFilterNumberTo) return false;
        }
        break;

      default:
    }

    if ((_followUpEmployeeRequest
                .contains(dr['employee'].toString().toLowerCase() + ',') ||
            controlUser.drNow.data['name'].toString().toLowerCase() ==
                'admin') ==
        false) return false;

    return (dr['customer'] +
                dr['typeIs'] +
                dr['requiredImplementation'] +
                dr['employee'])
            .toLowerCase()
            .contains(_search) &&
        (widget.filterType.isEmpty
            ? true
            : dr['typeIs'] == widget.filterType) &&
        (widget.filterEmployee.isEmpty
            ? true
            : dr['employee'] == widget.filterEmployee);
  }

  void _searchApply(String v) {
    setState(() {
      _search = v;
    });
  }

  void _searchClear() {
    setState(() {
      _search = '';
      _searchController = TextEditingController(text: '');
    });
  }

  void _new() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestEditUI.UI(dr)));
  }

  void _win(DocumentSnapshot dr) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestWinUI.UI(dr)));
  }

  void _imageZoom(DocumentSnapshot dr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                requestImageListUI.UI(double.parse(dr.documentID.toString()))));
  }

  void _viewMap(DocumentSnapshot dr) async {
    drCustomer =
        await controlCustomer.getDataRow(dr.data['customerID'].toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => mapGoogleViewUI.UI(
                drCustomer.data['name'],
                drCustomer.data['phones'],
                drCustomer.data['mapLocation'])));
  }

  DocumentSnapshot drCustomer;
  LatLng _mapLocation;
  void _editMap(DocumentSnapshot dr) async {
    drCustomer =
        await controlCustomer.getDataRow(dr.data['customerID'].toString());
    _mapLocation = LatLng(drCustomer.data['mapLocation'].latitude,
        drCustomer.data['mapLocation'].longitude);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                mapBoxSelectUI.UI(_saveLocation, _mapLocation)));
  }

  void _saveLocation(LatLng location) async {
    await controlCustomer.editLocation(homePageUI.scaffoldKey,
        drCustomer.documentID, GeoPoint(location.latitude, location.longitude));
  }
}
