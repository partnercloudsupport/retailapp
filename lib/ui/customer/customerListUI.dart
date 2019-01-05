import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/ui/customer/customerNewUI.dart' as customerNewUI;
import 'package:retailapp/ui/customer/customerEditUI.dart' as customerEditUI;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/mapGoogle/mapGoogleViewUI.dart' as mapGoogleViewUI;
import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _customerInsert = controlPermission.drNow.data['customerInsert'];
  bool _customerEdit = controlPermission.drNow.data['customerEdit'];
  bool _searchActive = false;
  String _search = '';
  TextEditingController _searchController = TextEditingController(text: '');
  AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controlPermission.getMe();
    setState(() {
      _customerInsert = controlPermission.drNow.data['customerInsert'];
      _customerEdit = controlPermission.drNow.data['customerEdit'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        drawer: homeDrawer.buildDrawer(context),
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              _buildFilter(),
              _buildList(),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFilter() {
    return _searchActive
        ? SizeTransition(
            axis: Axis.horizontal,
            sizeFactor:
                CurvedAnimation(parent: _ac, curve: Curves.fastOutSlowIn),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1.0, color: myColor.color1))),
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: myColor.color1,
                          ),
                          onTap: _searchReactive,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.search,
                            color: myColor.color1,
                          ),
                          onTap: _searchApply,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: true,
                          style: myStyle.style15Color1(),
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                myLanguage.text(myLanguage.item.search) + '...',
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
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _buildAppBar() {
    return _searchActive
        ? null
        : AppBar(
            title: Text(myLanguage.text(myLanguage.item.contacts)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _searchReactive,
              )
            ],
          );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlCustomer.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return (v['name'] + v['address'] + v['phones'])
                  .toLowerCase()
                  .contains(_search);
            }).map((DocumentSnapshot dr) {
              return _buildCard(dr);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return ExpansionTile(
      title: Text(
        dr['name'],
        style: myStyle.style20Color1(),
      ),
      leading: dr['phones'].toString().isEmpty
          ? Icon(
              Icons.phone,
              color: Colors.red,
            )
          : Text(
              dr['phones'],
            ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  dr['address'].toString().isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['address'],
                              style: myStyle.style16Color1Italic()),
                        ),
                  dr['note'].toString().isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['note'],
                              style: myStyle.style16Color1Italic()),
                        ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildViewMapButton(dr),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
    return _customerEdit
        ? IconButton(
            icon: Icon(
              Icons.edit,
              color: myColor.color1,
            ),
            onPressed: () => _edit(dr),
          )
        : SizedBox();
  }

  Widget _buildNeedInsertOrUpdate(DocumentSnapshot dr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        dr['needInsert'] == false
            ? Container()
            : Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                child: Icon(
                  Icons.add,
                  color: Colors.red,
                ),
              ),
        dr['needUpdate'] == false
            ? Container()
            : Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                child: Icon(
                  Icons.update,
                  color: Colors.red,
                ),
              )
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return _customerInsert
        ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _new,
            backgroundColor: myColor.color1,
          )
        : null;
  }

  void _searchReactive() {
    setState(() {
      _searchActive = !_searchActive;
      _searchController = TextEditingController(text: '');
      _searchApply();

      if (_searchActive) {
        _ac.reset();
        _ac.forward();
      }
    });
  }

  void _searchApply() {
    setState(() {
      _search = _searchController.text;
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
        context, MaterialPageRoute(builder: (context) => customerNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => customerEditUI.UI(dr)));

    // Navigator.pushAndRemoveUntil(
    //   this.context,
    //   MaterialPageRoute(
    //       builder: (BuildContext context) => customerEditUI.UI(dr)),
    //   ModalRoute.withName('/'),
    // );
  }

  void _viewMap(DocumentSnapshot dr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => mapGoogleViewUI.UI(
                dr.data['name'], dr.data['phones'], dr.data['mapLocation'])));
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _searchController.dispose();
  }
}
