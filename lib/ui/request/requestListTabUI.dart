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
  final int statusIs;
  final int stageIs;
  UI(this._querySnapshot, this.statusIs, this.stageIs);

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget._querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildTextLoading();

        return ListView(
          children: v.data.documents.map((DocumentSnapshot dr) {
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
    return dr['statusIs'] != widget.statusIs || dr['stageIs'] < widget.stageIs
        ? SizedBox()
        : Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ExpansionTile(
                  leading: Text(dr.documentID + ' | ' + dr['typeIs']),
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
          );
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

  void _new() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestEditUI.UI(dr)));
  }
}
