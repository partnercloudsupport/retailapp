import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/ui/customer/customerNewUI.dart';
import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class CustomerSelectUI extends StatefulWidget {
  final void Function(String) _save;
  final bool withNew;
  CustomerSelectUI(this._save, {this.withNew = false});

  @override
  CustomerSelectUIState createState() => CustomerSelectUIState();
}

class CustomerSelectUIState extends State<CustomerSelectUI>
    with SingleTickerProviderStateMixin {
  bool customerInsert = controlPermission.drNow.data['customerInsert'];
  String _filter = '';
  TextEditingController _textEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    initStateMe();
    super.initState();
  }

  void initStateMe() async {
    await controlPermission.getMe();
    setState(() {
      customerInsert = controlPermission.drNow.data['customerInsert'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
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
      title: Text(MyLanguage.text(myLanguageItem.chooseACustomer)),
    );
  }

  Widget _buildFilter() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: MyColor.color1))),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(
                    Icons.search,
                    color: MyColor.color1,
                  ),
                  onTap: _filterApply,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    style: MyStyle.style15Color1(),
                    controller: _textEditingController,
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
        print(dr['name']);

        widget._save(dr['name']);
        Navigator.pop(context);
      },
      title: Text(
        dr['name'],
        style: MyStyle.style20Color1(),
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
    return widget.withNew && customerInsert
        ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _new,
            backgroundColor: MyColor.color1,
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
            builder: (context) => CustomerNewUI(
                  withdoAfterSave: widget.withNew,
                  doAfterSave: widget._save,
                )));
  }
}
