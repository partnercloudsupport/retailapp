import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;

import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class UI extends StatefulWidget {
  final void Function(String) _save;
  UI(this._save);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _filter = '';
  TextEditingController _textEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: <Widget>[
            _buildTextFieldFilter(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.chooseACustomer)),
    );
  }

  Widget _buildTextFieldFilter() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: MyColor.color1))),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    style: MyStyle.style15Color1(),
                    controller: _textEditingController,
                    onChanged: (v) => _filterApply(v),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: MyLanguage.text(myLanguageItem.search) + '...',
                    ),
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
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlEmployee.getShowInSchedule(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return v['name'].toString().contains(_filter);
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
      onTap: () {
        widget._save(dr['name']);
        Navigator.pop(context);
      },
      title: Text(
        dr['name'],
        style: MyStyle.style20Color1(),
      ),
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
      _textEditingController = TextEditingController(text: '');
    });
  }
}
