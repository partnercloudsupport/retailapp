import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/ui/myDiary/myDiaryEditUI.dart' as myDiaryEditUI;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/mapGoogle/mapGoogleViewUI.dart' as mapGoogleViewUI;
import 'package:retailapp/ui/myDiary/myDiaryNewUI.dart' as myDiaryNewUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final bool _searchActive;
  final String _searchText;
  final void Function(String) _searchSetText;

  UI(this._querySnapshot, this._searchActive, this._searchText,
      this._searchSetText);
  @override
  UIState createState() => UIState(_searchText);
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _searchActive = false;
  String _searchText;
  TextEditingController _searchController;

  AnimationController _ac;

  UIState(this._searchText);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _searchText);
    _ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
                        bottom: BorderSide(width: 1.0, color: myColor.color1))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          autofocus: true,
                          style: myStyle.style15(),
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
                      child: _searchText.isEmpty == true
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
      stream: widget._querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return ListView(
          children: v.data.documents.where((v) {
            return (v['customer'] + v['note'])
                    .toLowerCase()
                    .contains(_searchText) &&
                v['userID'].toString() == controlUser.drNow.documentID;
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
        style: myStyle.style20(),
      ),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dr['note'],
                  style: myStyle.style16Italic(),
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
                    color: myColor.grey,
                  ),
                  Text(dr['durationHourF'],
                      style: myStyle.style12Color3Italic()),
                ],
              ),
            ),
            _buildTypeIs(dr['typeIs']),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildViewMapButton(dr),
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

  Widget _buildViewMapButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.location_on,
        color: myColor.color1,
      ),
      onPressed: () => _viewMap(dr),
    );
  }

  Widget _buildEditButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: myColor.color1,
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 5.0),
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      onLongPress: () => _delete(dr),
    );
  }

  Widget _buildTypeIs(int v) {
    String t = 'lib/res/image/Prospect_001_32.png';

    switch (v) {
      case 0:
        t = 'lib/res/image/Company_002_32.png';
        break;
      case 1:
        t = 'lib/res/image/CallerID_003_32.png';
        break;
      case 2:
        t = 'lib/res/image/Outdoor_001_32.png';
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        t,
        color: myColor.grey,
        height: 16.0,
        width: 16.0,
      ),
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
        context, MaterialPageRoute(builder: (context) => myDiaryNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => myDiaryEditUI.UI(dr)));
  }

  void _viewMap(DocumentSnapshot dr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => mapGoogleViewUI.UI(
                dr.data['customer'], dr.data['note'], dr.data['mapLocation'])));
  }

  void _delete(DocumentSnapshot dr) async {
    if (await _deleteAskDialog() == 'Yes') {
      controlMyDiary.delete(scaffoldKey, dr.documentID);
    }
  }

  Future<String> _deleteAskDialog() async {
    var sd = SimpleDialog(
      title: Directionality(
        textDirection: myLanguage.rtl(),
        child: Text(myLanguage.text(myLanguage.item.delete),
            style: myStyle.style20Color4()),
      ),
      titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      children: <Widget>[
        Center(
          child: Text(
            myLanguage.text(myLanguage.item.areYouSureYouWantToDelete),
            style: myStyle.style18(),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        SizedBox(
          height: 2,
          child: Container(
            color: myColor.color1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(myLanguage.text(myLanguage.item.no),
                    style: myStyle.style16Italic()),
                onPressed: () => Navigator.pop(context, 'No'),
              ),
              Expanded(
                child: Text(''),
              ),
              SimpleDialogOption(
                child: Text(myLanguage.text(myLanguage.item.yes),
                    style: myStyle.style16Color4()),
                onPressed: () => Navigator.pop(context, 'Yes'),
              ),
            ],
          ),
        )
      ],
    ).build(context);

    return await showDialog(context: context, builder: (BuildContext bc) => sd);
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _searchController.dispose();
  }
}