import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/ui/homePage/homeDrawer.dart' as homeDrawer;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/ui/customer/customerEditUI.dart' as customerEditUI;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/mapGoogle/mapGoogleViewUI.dart' as mapGoogleViewUI;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _searchActive = false;
  String _search = '';
  TextEditingController _searchController = TextEditingController(text: '');

  AnimationController _ac;

  @override
  void initState() {
    super.initState();

    _ac =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
                      Flexible(
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
            title: Text(myLanguage.text(myLanguage.item.myDiaries)),
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
      stream: controlMyDiary.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return (v['customer'] + v['note'])
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
      leading: Text(
        dr['amountF'],
      ),
      title: Text(
        dr['customer'],
        style: myStyle.style20(),
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(dr['note'], style: myStyle.style16Italic()),
                ),
              ],
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
        dr['needInsert'] == false ? Container() : _buildNeedAction(Icons.add),
        dr['needUpdate'] == false
            ? Container()
            : _buildNeedAction(Icons.update),
        _buildNeedDelete(dr),
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

  Widget _buildNeedDelete(DocumentSnapshot dr) {
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
      child: Icon(Icons.add),
      onPressed: _new,
      backgroundColor: myColor.color1,
    );
  }

  void _searchReactive() {
    setState(() {
      _searchActive = !_searchActive;
      _searchController = TextEditingController(text: '');
      _searchApply('');

      if (_searchActive) {
        _ac.reset();
        _ac.forward();
      }
    });
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
    controlMyDiary.save(
        'love', DateTime.now(), DateTime.now(), 'note', 12, 0, 1);

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => customerNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => customerEditUI.UI(dr)));
  }

  void _viewMap(DocumentSnapshot dr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => mapGoogleViewUI.UI(
                dr.data['customer'], dr.data['note'], dr.data['mapLocation'])));
  }

  void _delete(DocumentSnapshot dr) {
    controlMyDiary.delete(dr.documentID);
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _searchController.dispose();
  }
}
