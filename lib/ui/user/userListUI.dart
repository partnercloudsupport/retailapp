import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/homePage/homeDrawerUI.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/user/controluser.dart' as controlUser;

class UserListUI extends StatefulWidget {
  @override
  UserListUIState createState() => UserListUIState();
}

class UserListUIState extends State<UserListUI>
    with SingleTickerProviderStateMixin {
  bool _filterActive = false;
  String _filter = '';
  TextEditingController _textEditingController =
      TextEditingController(text: '');

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
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        drawer: HomeDrawerUI.buildDrawer(context),
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              _buildTextFieldFilter(),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldFilter() {
    return _filterActive
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
                              BorderSide(width: 1.0, color: MyColor.color1))),
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: MyColor.color1,
                          ),
                          onTap: _filterReactive,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: true,
                          style: MyStyle.style15Color1(),
                          controller: _textEditingController,
                          onChanged: (v) => _filterApply(v),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                MyLanguage.text(myLanguageItem.search) + '...',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: _filter.isEmpty == true
                            ? SizedBox(width: 0)
                            : InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: MyColor.color1,
                                ),
                                onTap: _filterClear,
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
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _buildAppBar() {
    return _filterActive
        ? null
        : AppBar(
            title: Text(MyLanguage.text(myLanguageItem.contacts)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _filterReactive,
              )
            ],
          );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlUser.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return v['name'].toString().contains(_filter) ||
                  v['permission'].toString().contains(_filter);
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
        style: MyStyle.style20Color1(),
      ),
      leading: Text(
        dr['permission'],
      ),
      children: <Widget>[
        Container(
          height: 150.0,
          width: 150.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(dr['imageURL'].toString()))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildNeedInsertOrUpdate(dr),
                ],
              ),
            )
          ],
        )
      ],
    );
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

  void _filterReactive() {
    setState(() {
      _filterActive = !_filterActive;
      _textEditingController = TextEditingController(text: '');
      _filterApply('');

      if (_filterActive) {
        _ac.reset();
        _ac.forward();
      }
    });
  }

  void _filterApply(String v) {
    setState(() {
      _filter = v;
    });
  }

  void _filterClear() {
    setState(() {
      _filter = '';
      _textEditingController = TextEditingController(text: '');
    });
  }
}
