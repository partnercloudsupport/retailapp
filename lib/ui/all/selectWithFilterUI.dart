import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectWithFilterUI extends StatefulWidget {
  final Stream<QuerySnapshot> _querySnapshot;
  final void Function(String) _save;
  final String _titleUI;
  final bool autofocus;

  SelectWithFilterUI(this._querySnapshot, this._save, this._titleUI, {this.autofocus = true});

  @override
  SelectWithFilterUIState createState() => SelectWithFilterUIState();
}

class SelectWithFilterUIState extends State<SelectWithFilterUI> with SingleTickerProviderStateMixin {
  String _filter = '';
  TextEditingController _textEditingController =
      TextEditingController(text: '');

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
      title: Text(widget._titleUI),
      actions: <Widget>[
        _buildClear(),
      ],
    );
  }

  Widget _buildClear() {
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: Colors.white,
      ),
      onPressed: () => save(''),
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
                    autofocus: widget.autofocus,
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
      stream: widget._querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return Center(child: CircularProgressIndicator());
        return Flexible(
          child: ListView(
            children: v.data.documents.where((v) {
              return v['name']
                  .toString()
                  .toLowerCase()
                  .contains(_filter.toLowerCase());
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
      onTap: () => save(dr['name']),
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

  void save(String v) {
    widget._save(v);
    Navigator.pop(context);
  }
}
