import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/CallerLog/controlCallerLog.dart'
    as controlCallerLog;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/request/requestNewUI.dart' as requestNewUI;
import 'package:retailapp/ui/callerLog/callerLogEditUI.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class CallerLogListTabUI extends StatefulWidget {
  final Stream<QuerySnapshot> querySnapshot;
  CallerLogListTabUI(this.querySnapshot, {this.withFilterAction = false});

  final bool withFilterAction;

  @override
  _CallerLogListTabUIState createState() => _CallerLogListTabUIState(querySnapshot);
}

class _CallerLogListTabUIState extends State<CallerLogListTabUI> {
  _CallerLogListTabUIState(Stream<QuerySnapshot> querySnapshot) {
    _querySnapshot = querySnapshot;
  }

  Stream<QuerySnapshot> _querySnapshot;
  BuildContext _bc;
  DateTime _fromDate;
  DateTime _toDate;

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
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
            onPressed: _showFilter,
            backgroundColor: MyColor.color1,
          );
  }

  Widget _buildTextLoading() {
    return Center(
      child: super.widget.withFilterAction
          ? Text(
              MyLanguage.text(myLanguageItem.clickOnTheFilterButtonToLoadData),
              style: MyStyle.style20Color1(),
            )
          : CircularProgressIndicator(),
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpansionTile(
            leading: Text(
              dr['phone'],
            ),
            title: Text(
              dr['customer'],
              style: MyStyle.style20Color1(),
            ),
            trailing: Text(
              MyDateTime.formatAndShortByFromString(dr['dateTimeIs'].toString(),
                  MyDateTimeFormatTypes.ddMMyyyyhhmma),
            ),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dr['noteIs'],
                      style: MyStyle.style15Color1(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildNewRequest(dr),
                      _buildEditButton(dr),
                      _buildNeedInsertOrUpdate(dr),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewRequest(DocumentSnapshot dr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: dr['isLinkWithRequest']
          ? SizedBox()
          : InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Request',
                    style: MyStyle.style14Color1(),
                  ),
                  Icon(
                    Icons.add,
                    color: MyColor.color1,
                  ),
                ],
              ),
              onTap: () => _newRequest(dr['customer'], dr['noteIs']),
            ),
    );
  }

  Widget _buildNeedInsertOrUpdate(DocumentSnapshot dr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        dr['needUpdate']
            ? Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                child: Icon(
                  Icons.update,
                  color: Colors.red,
                ),
              )
            : SizedBox()
      ],
    );
  }

  Widget _buildEditButton(DocumentSnapshot dr) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: MyColor.color1,
      ),
      onPressed: () => _edit(dr),
    );
  }

  void _showFilter() async {
//controlCallerLog.addSomeColumn();

    var f = SimpleDialog(
      title: Directionality(
        textDirection: MyLanguage.rtl(),
        child: Text(MyLanguage.text(myLanguageItem.filterSettings),
            style: MyStyle.style20Color1()),
      ),
      titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      contentPadding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      children: <Widget>[
        Directionality(
          textDirection: MyLanguage.rtl(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  MyLanguage.text(myLanguageItem.fromDate) + ':',
                  style: MyStyle.style20Color1(),
                ),
                RaisedButton(
                  child: Text(
                      MyDateTime.formatBy(
                          _fromDate, MyDateTimeFormatTypes.ddMMyyyy),
                      style: MyStyle.style20Color1()),
                  onPressed: _selectFromDate,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  MyLanguage.text(myLanguageItem.toDate) + ':',
                  style: MyStyle.style20Color1(),
                ),
                RaisedButton(
                  child: Text(
                      MyDateTime.formatBy(
                          _toDate, MyDateTimeFormatTypes.ddMMyyyy),
                      style: MyStyle.style20Color1()),
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
                child: Text(MyLanguage.text(myLanguageItem.cancel),
                    style: MyStyle.style16Color1Italic()),
                onPressed: () => Navigator.pop(_bc, 'Cancel'),
              ),
              Expanded(
                child: Text(''),
              ),
              SimpleDialogOption(
                child: Text(MyLanguage.text(myLanguageItem.search),
                    style: MyStyle.style16Color1()),
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

  void _newRequest(String customer, String requiredImplementation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => requestNewUI.UI(
                  customer: customer,
                  requiredImplementation: requiredImplementation,
                )));
  }

  void _edit(DocumentSnapshot dr) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallerLogEditUI(dr)));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
