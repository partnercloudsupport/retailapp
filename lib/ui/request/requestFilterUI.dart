import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/all/selectWithFilterUI.dart' as selectWithFilterUI;
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/request/controlRequestType.dart'
    as controlRequestType;

String _filterEmployee = '';
String _filterType = '';

class UI extends StatefulWidget {
  final void Function(String, String) _save;

  UI(this._save, String filterEmployee, String filterType) {
    _filterEmployee = filterEmployee;
    _filterType = filterType;
  }

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildEmployeeChoose(),
              _buildRequestTypeChoose(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.TextIndex.filterRequests)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _save,
        )
      ],
    );
  }

  Widget _buildEmployeeChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.master)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    myLanguage.text(myLanguage.TextIndex.chooseAnEmployee),
                    style: myStyle.dateLevel12(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(_filterEmployee, style: myStyle.textEdit15()),
                  ),
                ],
              ),
            ),
            _filterEmployee.isEmpty
                ? SizedBox()
                : InkWell(
                    child: Icon(Icons.clear),
                    onTap: _clearEmployee,
                  )
          ],
        ),
      ),
      onTap: _openChooseEmployee,
    );
  }

  Widget _buildRequestTypeChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.master)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    myLanguage.text(myLanguage.TextIndex.chooseARequestType),
                    style: myStyle.dateLevel12(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(_filterType, style: myStyle.textEdit15()),
                  ),
                ],
              ),
            ),
            _filterType.isEmpty
                ? SizedBox()
                : InkWell(
                    child: Icon(Icons.clear),
                    onTap: _clearType,
                  )
          ],
        ),
      ),
      onTap: _openChooseRequestType,
    );
  }

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlEmployee.getAll(),
                  _chooseEmployee,
                  myLanguage.text(myLanguage.TextIndex.chooseAnEmployee),
                  autofocus: false,
                )));
  }

  void _chooseEmployee(String v) {
    setState(() {
      _filterEmployee = v;
    });
  }

  void _clearEmployee() {
    setState(() {
      _filterEmployee = '';
    });
  }

  void _openChooseRequestType() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlRequestType.getAll(),
                  _chooseRequestType,
                  myLanguage.text(myLanguage.TextIndex.chooseARequestType),
                  autofocus: false,
                )));
  }

  void _chooseRequestType(String v) {
    setState(() {
      _filterType = v;
    });
  }

  void _clearType() {
    setState(() {
      _filterType = '';
    });
  }

  void _save() {
    widget._save(_filterType, _filterEmployee);
    Navigator.pop(context);
  }
}
