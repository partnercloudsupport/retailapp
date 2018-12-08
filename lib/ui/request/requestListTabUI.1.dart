import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/request/requestNewUI.dart' as requestNewUI;
import 'package:retailapp/control/request/controlRequestNote.dart'
    as controlRequestNote;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final int statusIs;
  UI(this._querySnapshot, this.statusIs);

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  String _note = '';
  TextEditingController _noteController = TextEditingController();

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
    return dr['statusIs'] != widget.statusIs
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
                            _buildPendingButton(),
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
                        ),
                        Column(
                          children: <Widget>[
                            _builTextNote(dr),
                            Card(
                                elevation: 2.0,
                                color: myColor.master,
                                child: _buildListNote(dr)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildPendingButton() {
    return IconButton(
      icon: Icon(
        Icons.style,
        color: myColor.master,
      ),
      onPressed: () => {},
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

  Widget _builTextNote(DocumentSnapshot dr) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: Row(
        children: <Widget>[
          _note.isEmpty == false
              ? IconButton(
                  icon: Icon(
                    Icons.save,
                    color: myColor.master,
                  ),
                  onPressed: () => _saveNote(dr),
                )
              : SizedBox(),
          Expanded(
            child: TextField(
              controller: _noteController,
              textInputAction: TextInputAction.done,
              style: myStyle.textEdit15(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: myLanguage.text(myLanguage.TextIndex.note)),
              onChanged: (String v) {
                setState(() {
                  _note = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListNote(DocumentSnapshot dr) {
    return StreamBuilder<QuerySnapshot>(
      stream: controlRequestNote.getOfRequest(double.parse(dr.documentID)),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildTextLoading();

        return Container(
          height: 180.0,
          child: ListView(
            children: v.data.documents.map((DocumentSnapshot dr) {
              return _buildCardNote(dr);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCardNote(DocumentSnapshot dr) {
    return Card(
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              dr['user'],
              style: myStyle.dateLevel12(),
            ),
            Text(
              dr['note'],
              style: myStyle.masterLevel16(),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                child: Text(
                  myDateTime.formatAndShortByFromString(
                      dr['dateTimeIs'].toString(),
                      myDateTime.Types.ddMMyyyyhhmma),
                  textAlign: TextAlign.end,
                  style: myStyle.dateLevel12(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildNeedInsertOrUpdate(dr),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _saveNote(DocumentSnapshot dr) {
    controlRequestNote.save(
        double.parse(dr.documentID), controlUser.drNow['name'], _note);

    setState(() {
      _note = '';
      _noteController.clear();
    });
  }

  void _new() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestNewUI.UI()));
  }

  void _edit(DocumentSnapshot dr) {
    controlRequestNote.save(
        dr['requestID'], controlUser.drNow['name'], 'new note');
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => requestNewUI.UI()));

    // Navigator.pushAndRemoveUntil(
    //   this.context,
    //   MaterialPageRoute(
    //       builder: (BuildContext context) => customerEditUI.UI(dr)),
    //   ModalRoute.withName('/'),
    // );
  }
}
