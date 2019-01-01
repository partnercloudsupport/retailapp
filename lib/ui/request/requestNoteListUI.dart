import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/request/controlRequestNote.dart'
    as controlRequestNote;

import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

class UI extends StatefulWidget {
  final double requestID;
  UI(this.requestID);
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  bool _filterActive = false;
  String _filter = '';
  TextEditingController _filterController = TextEditingController(text: '');
  String _note = '';
  TextEditingController _noteController = TextEditingController(text: '');

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
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              _buildFilter(),
              _buildNote(),
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return _filterActive
        ? null
        : AppBar(
            title: Text(myLanguage.text(myLanguage.item.timelineNotes)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _filterReactive,
              )
            ],
          );
  }

  Widget _buildFilter() {
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
                          onTap: _filterReactive,
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: true,
                          style: myStyle.style15Color1(),
                          controller: _filterController,
                          onChanged: (v) => _filterApply(v),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                myLanguage.text(myLanguage.item.search) + '...',
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
                                  color: myColor.color1,
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

  Widget _buildNote() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: myColor.color1))),
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  autofocus: true,
                  style: myStyle.style15Color1(),
                  controller: _noteController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: myLanguage.text(myLanguage.item.note),
                  ),
                  onChanged: _noteApply,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: _note.isEmpty == true
                    ? SizedBox(width: 0)
                    : InkWell(
                        child: Icon(
                          Icons.save,
                          color: myColor.color1,
                        ),
                        onTap: _save,
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
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlRequestNote.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return (v['user'].toString().toLowerCase().contains(_filter) ||
                      v['note'].toString().toLowerCase().contains(_filter)) &&
                  v['requestID'] == widget.requestID;
            }).map((DocumentSnapshot dr) {
              return _buildCard(dr);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return ListTile(
      title: Text(
        dr['note'],
        style: myStyle.style20Color1(),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              dr['user'],
            ),
          ),
          Text(
            myDateTime.formatAndShortByFromString(
                dr['dateTimeIs'].toString(), myDateTime.Types.ddMMyyyyhhmma),
            textAlign: TextAlign.end,
            style: myStyle.style12Color3(),
          ),
          SizedBox(
            width: 8.0,
          ),
          _buildStage(dr['stageIs']),
          _buildNeedInsertOrUpdate(dr),
        ],
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

  Widget _buildStage(int v) {
    String t = 'lib/res/image/Prospect_001_32.png';

    switch (v) {
      case 1:
        t = 'lib/res/image/Prospect_001_32.png';
        break;
      case 2:
        t = 'lib/res/image/CallerID_003_32.png';
        break;
      case 3:
        t = 'lib/res/image/Request_003_32.png';
        break;
      case 4:
        t = 'lib/res/image/Quotation_002_32.png';
        break;
      case 5:
        t = 'lib/res/image/Installation_001_32.png';
        break;
      case 6:
        t = 'lib/res/image/MoneyCollection_001_32.png';
        break;
      case 7:
        t = 'lib/res/image/Win_001_32.png';
        break;
      case 9:
        t = 'lib/res/image/Close_004_32.png';
        break;
    }

    return Image.asset(
      t,
      color: myColor.color1,
      height: 16.0,
      width: 16.0,
    );
  }

  void _filterReactive() {
    setState(() {
      _filterActive = !_filterActive;
      _filterController = TextEditingController(text: '');
      _filterApply('');

      if (_filterActive) {
        _ac.reset();
        _ac.forward();
      }
    });
  }

  void _filterApply(String v) {
    setState(() {
      _filter = v.toLowerCase();
    });
  }

  void _filterClear() {
    setState(() {
      _filter = '';
      _filterController = TextEditingController(text: '');
    });
  }

  void _noteApply(String v) {
    setState(() {
      _note = v.toLowerCase();
    });
  }

  void _save() {
    controlRequestNote.save(widget.requestID, _note);

    setState(() {
      _note = '';
      _noteController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ac.dispose();
    _filterController.dispose();
    _noteController.dispose();
  }
}
