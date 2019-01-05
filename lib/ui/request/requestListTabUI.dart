import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final int _statusIs;
  final int _stageIs;
  final bool _searchActive;
  final String filterByType;
  final String filterByEmployee;

  UI(this._querySnapshot, this._statusIs, this._stageIs, this._searchActive,
      {this.filterByType = '', this.filterByEmployee = ''});

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _followUpEmployeeRequest = controlUser
      .drNow.data['followUpEmployeeRequest']
      .toString()
      .toLowerCase();

  String _search = '';
  TextEditingController _searchController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    controlUser.getMe();
    setState(() {
      _followUpEmployeeRequest = controlUser
          .drNow.data['followUpEmployeeRequest']
          .toString()
          .toLowerCase();
    });
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
      stream: widget._querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildLoading();

        return ListView(
          children: v.data.documents.where((v) {
            return (v['customer'] +
                        v['typeIs'] +
                        v['requiredImplementation'] +
                        v['employee'])
                    .toLowerCase()
                    .contains(_search) &&
                (widget.filterByType.isEmpty
                    ? true
                    : v['typeIs'] == widget.filterByType) &&
                (widget.filterByEmployee.isEmpty
                    ? _followUpEmployeeRequest
                        .contains(v['employee'].toString().toLowerCase())
                    : (v['employee'] == widget.filterByEmployee) &&
                        _followUpEmployeeRequest
                            .contains(v['employee'].toString().toLowerCase()));
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
    return dr['statusIs'] == widget._statusIs &&
            dr['stageIs'] >= widget._stageIs
        ? Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ExpansionTile(
                  leading: Text(dr['typeIs']),
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
                          child: Text(dr['employee'],
                              style: myStyle.style16Color1Italic()),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                          child: Text(
                            myDateTime.formatAndShortByFromString(
                                dr['appointment'].toString(),
                                myDateTime.Types.ddMMyyyyhhmma),
                            textAlign: TextAlign.end,
                            style: myStyle.style12Color3(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _buildNote(dr),
                            SizedBox(
                              width: 8,
                            ),
                            _buildImage(dr),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  _buildWin(dr),
                                  _buildEdit(dr),
                                  _buildNeedInsertOrUpdate(dr),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget _buildWin(DocumentSnapshot dr) {
    return IconButton(
      icon: Image.asset(
        'lib/res/image/Win_001_32.png',
        color: myColor.color1,
        height: 24.0,
        width: 24.0,
      ),
      onPressed: () => _win(dr),
    );
  }

  Widget _buildEdit(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: myColor.color1,
      ),
      onPressed: () => _edit(dr),
    );
  }

  Widget _buildNote(DocumentSnapshot dr) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        child: Row(
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
                          myString
                              .betweenBrackets(dr['notesCount'].toString())),
              style: myStyle.style14Color1(),
            ),
          ],
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => requestNoteListUI
                    .UI(double.parse(dr.documentID.toString())))),
      ),
    );
  }

  Widget _buildImage(DocumentSnapshot dr) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        child: Row(
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
                          myString
                              .betweenBrackets(dr['imageCount'].toString())),
              style: myStyle.style14Color1(),
            ),
          ],
        ),
        onTap: () => _imageZoom(dr),
      ),
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
}
