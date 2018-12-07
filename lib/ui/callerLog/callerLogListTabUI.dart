import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/control/CallerLog/controlCallerLog.dart'
    as controlCallerLog;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myColor.dart' as myColor;

class UI extends StatefulWidget {
  final Stream<QuerySnapshot> querySnapshot;
  UI(this.querySnapshot, {this.withFilterAction = false});

  final bool withFilterAction;

  @override
  _UIState createState() => _UIState(querySnapshot);
}

class _UIState extends State<UI> {
  _UIState(Stream<QuerySnapshot> querySnapshot) {
    _querySnapshot = querySnapshot;
  }

  Stream<QuerySnapshot> _querySnapshot;
  BuildContext _bc;
  DateTime _fromDate;
  DateTime _toDate;

  @override
  void initState() {
    super.initState();

    if (super.widget.withFilterAction && _fromDate != null && _toDate != null) {
      _querySnapshot = controlCallerLog.getBetweenData(_fromDate, _toDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    _bc = context;
    return _buildList(super.widget.withFilterAction);
  }

  Widget _buildList(bool withFilterAction) {
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData)
          return Scaffold(
              floatingActionButton: _buildFloatingActionButton(context),
              body: _buildTextLoading());

        return Scaffold(
          floatingActionButton: _buildFloatingActionButton(context),
          body: ListView(
            children: v.data.documents.map((DocumentSnapshot document) {
              return _buildCard(document);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext bc) {
    return super.widget.withFilterAction == false
        ? null
        : FloatingActionButton(
            child: Icon(Icons.find_in_page),
            onPressed: () {
              _showFilter();
            },
            backgroundColor: myColor.master,
          );
  }

  Widget _buildTextLoading() {
    return Center(
      child: super.widget.withFilterAction
          ? Text(
              myLanguage
                  .text(myLanguage.TextIndex.clickOnTheFilterButtonToLoadData),
              style: myStyle.textEdit(),
            )
          : CircularProgressIndicator(),
    );
  }

  Widget _buildCard(DocumentSnapshot document) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: Text(
              document['phone'] + " - " + document['customer'],
              style: myStyle.textEdit(),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                document['noteIs'],
                style: myStyle.masterLevel2(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
            child: Text(
              myDateTime.formatAndShortByFromString(
                  document['dateTimeIs'].toString(),
                  myDateTime.Types.ddMMyyyyhhmma),
              textAlign: TextAlign.end,
              style: myStyle.dateLevel1(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilter() async {
    var f = SimpleDialog(
      title: Directionality(
        textDirection: myLanguage.rtl(),
        child: Text(myLanguage.text(myLanguage.TextIndex.filterSettings),
            style: myStyle.textEdit()),
      ),
      titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      children: <Widget>[
        Directionality(
          textDirection: myLanguage.rtl(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  myLanguage.text(myLanguage.TextIndex.fromDate) + ':',
                  style: myStyle.textEdit(),
                ),
                RaisedButton(
                  child: Text(
                      myDateTime.formatBy(_fromDate, myDateTime.Types.ddMMyyyy),
                      style: myStyle.textEdit()),
                  onPressed: _selectFromDate,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  myLanguage.text(myLanguage.TextIndex.toDate) + ':',
                  style: myStyle.textEdit(),
                ),
                RaisedButton(
                  child: Text(
                      myDateTime.formatBy(_toDate, myDateTime.Types.ddMMyyyy),
                      style: myStyle.textEdit()),
                  onPressed: _selectToDate,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(myLanguage.text(myLanguage.TextIndex.cancel),
                    style: myStyle.masterLevel2()),
                onPressed: () => Navigator.pop(_bc, 'Cancel'),
              ),
              Expanded(
                child: Text(''),
              ),
              SimpleDialogOption(
                child: Text(myLanguage.text(myLanguage.TextIndex.search),
                    style: myStyle.masterLevel1()),
                onPressed: () => Navigator.pop(_bc, 'Ok'),
              ),
            ],
          ),
        )
      ],
    ).build(_bc);

    _save(await showDialog(context: _bc, builder: (BuildContext bc) => f));
  }

  void _selectFromDate() async {
    DateTime dateTime = DateTime.now();

    dateTime = await showDatePicker(
        firstDate: DateTime(2017),
        lastDate: DateTime.now(),
        initialDate: _fromDate == null ? dateTime : _fromDate,
        context: _bc);

    if (dateTime != null) {
      setState(() {
        _fromDate = dateTime;
      });
    }

    Navigator.pop(_bc, 'Cancel');
    _showFilter();
  }

  void _selectToDate() async {
    DateTime dateTime = DateTime.now();

    dateTime = await showDatePicker(
        firstDate: DateTime(2017),
        lastDate: DateTime.now(),
        initialDate: _toDate == null ? dateTime : _toDate,
        context: _bc);

    if (dateTime != null) {
      setState(() {
        _toDate = dateTime;
      });
    }

    Navigator.pop(_bc, 'Cancel');
    _showFilter();
  }

  void _save(String v) {
    if (v == 'Ok') {
      setState(() {
        _querySnapshot = controlCallerLog.getBetweenData(_fromDate, _toDate);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}