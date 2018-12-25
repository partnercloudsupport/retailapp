import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/customer/customerSelectUI.dart'
    as customerSelectUI;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:retailapp/control/my/myRegExp.dart' as myRegExp;
import 'package:retailapp/control/my/mydouble.dart' as mydouble;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final formKey = GlobalKey<FormState>();

  String _customer = '';
  DateTime _beginDate = DateTime.now();
  TimeOfDay _beginTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();

  String _note = '';
  double _amount = 0;
  int _typeIs = 0;

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();

  final dateFormat = DateFormat("EEEE, d-MM-yyyy 'at' h:mma");

  @override
  Widget build(BuildContext context) {
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
      myLanguage.text(myLanguage.item.newADailyEvent),
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
              _buildCustomerChoose(),
              _buildTimeFromTo(),
              _buildNote(),
              _buildAmount(),
              _buildTypeIs(),
            ],
          )),
    );
  }

  Widget _buildCustomerChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              myLanguage.text(myLanguage.item.chooseACustomer),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_customer, style: myStyle.style15()),
            ),
          ],
        ),
      ),
      onTap: _openChooseCustomer,
    );
  }

  Widget _buildTimeFromTo() {
    return Row(
      children: <Widget>[
        _buildTime(_chooseBeginTime, myLanguage.item.from, _beginTime),
        _buildTime(_chooseEndTime, myLanguage.item.to, _endTime),
      ],
    );
  }

  Widget _buildTime(
      void Function() save, myLanguage.item _text, TimeOfDay time) {
    return InkWell(
      child: Container(
        width: (MediaQuery.of(context).size.width - 20) / 2,
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              myLanguage.text(_text),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  myDateTime.formatTimeOfDayBy(time, myDateTime.Types.hhmma),
                  style: myStyle.style15()),
            ),
          ],
        ),
      ),
      onTap: save,
    );
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _note,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: myStyle.style15(),
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.item.weTalkedAbout)),
      onSaved: (String v) => _note = v,
      focusNode: _focusNode1,
    );
  }

  Widget _buildAmount() {
    return TextFormField(
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(myRegExp.number1To9999999),
        ],
        textInputAction: TextInputAction.done,
        style: myStyle.style15(),
        decoration: InputDecoration(
            labelText: myLanguage.text(myLanguage.item.resultingAmount)),
        onSaved: (String v) => _amount = mydouble.to(v),
        focusNode: _focusNode2);
  }

  Widget _buildTypeIs() {
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
              myLanguage.text(myLanguage.item.type),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_typeIs.toString(), style: myStyle.style15()),
            ),
          ],
        ),
      ),
    );
  }

  void _openChooseCustomer() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => customerSelectUI.UI(_chooseCustomer)));
  }

  void _chooseCustomer(String v) {
    setState(() {
      _customer = v;
    });
  }

  void _chooseBeginTime() async {
    TimeOfDay v =
        await showTimePicker(context: context, initialTime: _beginTime);

    if (v != null) {
      setState(() {
        _beginTime = v;
      });
    }
  }

  void _chooseEndTime() async {
    TimeOfDay v = await showTimePicker(context: context, initialTime: _endTime);

    if (v != null) {
      setState(() {
        _endTime = v;
      });
    }
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
    if (_saveValidator() == true) {
      if (await controlMyDiary.save(
              _customer, _beginDate, _endDate, _note, _amount, _typeIs) ==
          true) {
        Navigator.pop(context);
      }
    }
  }
}
