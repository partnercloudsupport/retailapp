import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/control/my/myColor.dart' as myColor;

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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
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
      title: Text(myLanguage.text(myLanguage.TextIndex.chooseACustomer)),
    );
  }

  Widget _buildTextFieldFilter() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: myColor.master))),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    style: myStyle.textEdit15(),
                    controller: _textEditingController,
                    onChanged: (v) => _filterApply(v),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          myLanguage.text(myLanguage.TextIndex.search) + '...',
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
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlCustomer.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return v['name'].toString().contains(_filter) ||
                  v['phones'].toString().contains(_filter);
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
        style: myStyle.textEdit(),
      ),
      leading: dr['phones'].toString().isEmpty
          ? Icon(
              Icons.phone,
              color: Colors.red,
            )
          : Text(
              dr['phones'],
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