import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/customer/customerNewUI.dart' as customerNewUI;

class UI extends StatefulWidget {
  final void Function(String) _save;
  final bool withNew;
  UI(this._save, {this.withNew = false});

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
            _buildFilter(),
            _buildList(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.chooseACustomer)),
    );
  }

  Widget _buildFilter() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: myColor.color1))),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(
                    Icons.search,
                    color: myColor.color1,
                  ),
                  onTap: _filterApply,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    style: myStyle.style15Color1(),
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: myLanguage.text(myLanguage.item.search) + '...',
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
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlCustomer.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return CircularProgressIndicator();
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
        style: myStyle.style20Color1(),
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

  Widget _buildFloatingActionButton() {
    return widget.withNew
        ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _new,
            backgroundColor: myColor.color1,
          )
        : SizedBox();
  }

  void _filterApply() {
    setState(() {
      _filter = _textEditingController.text;
    });
  }

  void _filterClear() {
    setState(() {
      _filter = '';
      _textEditingController = TextEditingController(text: '');
    });
  }

  void _new() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => customerNewUI.UI(
                  withdoAfterSave: widget.withNew,
                  doAfterSave: widget._save,
                )));
  }
}
