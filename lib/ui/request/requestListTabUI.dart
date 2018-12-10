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

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final int _statusIs;
  final int _stageIs;
  final bool _filterActive;
  UI(this._querySnapshot, this._statusIs, this._stageIs, this._filterActive);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _filter = '';
  TextEditingController _filterController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildFilter(),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFilter() {
    return widget._filterActive
        ? Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: myColor.master))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          autofocus: true,
                          style: myStyle.textEdit15(),
                          controller: _filterController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                myLanguage.text(myLanguage.TextIndex.search) +
                                    '...',
                          ),
                          onChanged: _filterApply,
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
                                color: myColor.master,
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
                        color: myColor.master,
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
        if (!v.hasData) return _buildTextLoading();

        return ListView(
          children: v.data.documents.where((v) {
            return (v['customer'].toString() +
                    v['typeIs'].toString() +
                    v['requiredImplementation'].toString() +
                    v['employee'].toString())
                .toLowerCase()
                .contains(_filter);
          }).map((DocumentSnapshot dr) {
            return _buildCard(dr);
          }).toList(),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _new,
      backgroundColor: myColor.master,
    );
  }

  Widget _buildTextLoading() {
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
                  leading: Text(dr.documentID + dr['typeIs']),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dr['customer'],
                      style: myStyle.masterLevel16_1(),
                    ),
                  ),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['requiredImplementation'],
                              style: myStyle.masterLevel16_1()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['employee'],
                              style: myStyle.masterLevel16_1()),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                          child: Text(
                            myDateTime.formatAndShortByFromString(
                                dr['appointment'].toString(),
                                myDateTime.Types.ddMMyyyyhhmma),
                            textAlign: TextAlign.end,
                            style: myStyle.dateLevel12(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _buildNoteButton(dr),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  _buildPendingButton(dr),
                                  _buildEditButton(dr),
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

  Widget _buildPendingButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.pause,
        color: myColor.master,
      ),
      onPressed: () => {},
    );
  }

  Widget _buildNoteButton(DocumentSnapshot dr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Text(
          myLanguage.text(myLanguage.TextIndex.note) +
              ' ' +
              dr['notesCount'].toString(),
          style: myStyle.stylel12Italic(),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => requestNoteListUI
                    .UI(double.parse(dr.documentID.toString())))),
      ),
    );
  }

  Widget _buildEditButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: myColor.master,
      ),
      onPressed: () => _edit(dr),
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

  void _filterApply(String v) {
    setState(() {
      _filter = v;
    });
  }

  void _filterClear() {
    setState(() {
      _filter = '';
      _filterController = TextEditingController(text: '');
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
}
