import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myColor.dart' as myColor;

import 'package:retailapp/control/my/myRegExp.dart' as myRegExp;
import 'package:retailapp/ui/all/selectWithFilterUI.dart' as selectWithFilterUI;
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/my/mydouble.dart' as mydouble;

class UI extends StatefulWidget {
  final DocumentSnapshot dr;
  UI(this.dr);
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  BuildContext _context;
  final formKey = GlobalKey<FormState>();

  String _paidByEmployee = '';
  double _amount = 0;
  String _deleteNote = '';

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildForm(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: _buildTitle(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _save,
        )
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      myLanguage.text(myLanguage.item.requestCompleted),
      style: myStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              _buildEmployee(),
              _buildAmount(),
              _buildDeleteNote(),
            ],
          )),
    );
  }

  Widget _buildEmployee() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              myLanguage.text(myLanguage.item.chooseAnEmployee),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_paidByEmployee, style: myStyle.style15()),
            ),
          ],
        ),
      ),
      onTap: _openChooseEmployee,
    );
  }

  Widget _buildAmount() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(),
      inputFormatters: [
        WhitelistingTextInputFormatter(myRegExp.number1To9999999),
      ],
      textInputAction: TextInputAction.next,
      style: myStyle.style15(),
      decoration:
          InputDecoration(labelText: myLanguage.text(myLanguage.item.amount)),
      onSaved: (String v) => _amount = mydouble.to(v),
      focusNode: _focusNode1,
      onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_focusNode2),
    );
  }

  Widget _buildDeleteNote() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: 3,
      style: myStyle.style15(),
      decoration:
          InputDecoration(labelText: myLanguage.text(myLanguage.item.note)),
      onSaved: (String v) => _deleteNote = v,
      focusNode: _focusNode2,
    );
  }

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlEmployee.getAll(),
                  _chooseEmployee,
                  myLanguage.text(myLanguage.item.chooseAnEmployee),
                  autofocus: false,
                )));
  }

  void _chooseEmployee(String v) {
    setState(() {
      _paidByEmployee = v;
    });
    FocusScope.of(context).requestFocus(_focusNode1);
  }

  bool _saveValidator() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void _save() async {
//await controlRequest.addSomeColumn();

    if (_saveValidator() == true) {
      if (await controlRequest.win(
              widget.dr.documentID, _paidByEmployee, _amount, _deleteNote) ==
          true) {
        Navigator.pop(_context);
      }
    }
  }
}
