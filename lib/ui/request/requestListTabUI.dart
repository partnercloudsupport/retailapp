import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/request/requestNewUI.dart' as requestNewUI;

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final int statusIs;
  UI(this._querySnapshot, this.statusIs);

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
    return dr['statusIs'] != widget.statusIs
        ? SizedBox()
        : Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ExpansionTile(
                  leading: Text(dr['typeIs']),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dr['customer'],
                      style: myStyle.masterLevel2(),
                    ),
                  ),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['requiredImplementation'],
                              style: myStyle.masterLevel2()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(dr['employee'],
                              style: myStyle.masterLevel2()),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                          child: Text(
                            myDateTime.formatAndShortByFromString(
                                dr['appointment'].toString(),
                                myDateTime.Types.ddMMyyyyhhmma),
                            textAlign: TextAlign.end,
                            style: myStyle.dateLevel1(),
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

  void _new() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => requestNewUI.UI()));
  }
}
