import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/customer/customerSelectUI.dart'
    as customerSelectUI;
import 'package:retailapp/control/my/myRegExp.dart' as myRegExp;
import 'package:retailapp/control/my/mydouble.dart' as mydouble;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class UI extends StatefulWidget {
  final DocumentSnapshot dr;
  UI(this.dr);
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _customerValid = true;
  String _customer = '';
  DateTime _beginDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _beginTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _note = '';
  double _amountQuotation = 0;
  double _amount = 0;
  controlMyDiary.TypeIs _typeIs = controlMyDiary.TypeIs.visitCustomer;

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    _customer = widget.dr['customer'];
    _beginDate = widget.dr['beginDate'];
    _endDate = widget.dr['endDate'];
    _beginTime = TimeOfDay.fromDateTime(widget.dr['beginDate']);
    _beginTime = _beginTime.replacing(hour: _beginTime.hour);
    _endTime = TimeOfDay.fromDateTime(widget.dr['endDate']);
    _endTime = _endTime.replacing(hour: _endTime.hour);
    _note = widget.dr['note'];
    _amountQuotation = widget.dr['amountQuotation'];
    _amount = widget.dr['amount'];
    _typeIs = controlMyDiary.typeCast(widget.dr['typeIs']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        key: scaffoldKey,
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
      myLanguage.text(myLanguage.item.editADailyEvent),
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
              _buildAmountQuotation(),
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
            Row(
              children: <Widget>[
                Text('*', style: myStyle.style16Color4()),
                SizedBox(
                  width: 7,
                ),
                Text(
                  myLanguage.text(myLanguage.item.chooseACustomer),
                  style: myStyle.style12Color3(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_customer, style: myStyle.style15Color1()),
            ),
            _customerValid
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                        myLanguage.text(myLanguage.item.youMustChooseAValue),
                        style: myStyle.style14Color4()))
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
              myLanguage.text(_text) +
                  ' ' +
                  myDateTime.formatDateAndShort(_beginDate),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  myDateTime.formatTimeOfDayBy(time, myDateTime.Types.hhmma),
                  style: myStyle.style15Color1()),
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
      maxLines: 4,
      style: myStyle.style15Color1(),
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.item.weTalkedAbout)),
      onSaved: (String v) => _note = v,
      focusNode: _focusNode1,
    );
  }

  Widget _buildAmountQuotation() {
    return TextFormField(
        textInputAction: TextInputAction.next,
        initialValue: _amountQuotation.toStringAsFixed(0),
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(myRegExp.number1To9999999),
        ],
        style: myStyle.style15Color1(),
        decoration: InputDecoration(
            prefix: Text(r'$ ', style: myStyle.style14Color1()),
            suffix: Text(
              'USD',
              style: myStyle.style14Color1(),
            ),
            labelText: myLanguage.text(myLanguage.item.amountOfQuotation)),
        onFieldSubmitted: (String v) =>
            FocusScope.of(context).requestFocus(_focusNode2),
        onSaved: (String v) => _amountQuotation = mydouble.to(v));
  }

  Widget _buildAmount() {
    return TextFormField(
        initialValue: _amount.toStringAsFixed(0),
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(myRegExp.number1To9999999),
        ],
        style: myStyle.style15Color1(),
        decoration: InputDecoration(
            prefix: Text(r'$ ', style: myStyle.style14Color1()),
            suffix: Text(
              'USD',
              style: myStyle.style14Color1(),
            ),
            labelText: myLanguage.text(myLanguage.item.resultingAmount)),
        focusNode: _focusNode2,
        onSaved: (String v) => _amount = mydouble.to(v));
  }

  Widget _buildTypeIs() {
    return Container(
      decoration:
          UnderlineTabIndicator(borderSide: BorderSide(color: myColor.color1)),
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
          Wrap(
            children: <Widget>[
              _buildTypeItem(myLanguage.text(myLanguage.item.showroom),
                  controlMyDiary.TypeIs.showroom),
              _buildTypeItem(myLanguage.text(myLanguage.item.outgoingCall),
                  controlMyDiary.TypeIs.outgoingCall),
              _buildTypeItem(myLanguage.text(myLanguage.item.visitCustomer),
                  controlMyDiary.TypeIs.visitCustomer),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTypeItem(String _text, controlMyDiary.TypeIs valueIs) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Radio(
            value: valueIs,
            groupValue: _typeIs,
            onChanged: _chooseType,
          ),
          controlMyDiary.buildType(valueIs.index, myColor.color1),
          Text(
            _text,
            style: myStyle.style15Color1(),
          ),
        ],
      ),
      onTap: () => _chooseType(valueIs),
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
    _saveValidator();
  }

  void _chooseBeginTime() async {
    DateTime _beginDateNew = await showDatePicker(
      firstDate: DateTime.now().add(Duration(days: -10)),
      lastDate: DateTime.now().add(Duration(days: 1)),
      context: context,
      initialDate: _beginDate,
    );

    if (_beginDateNew == null) return;
    _beginDate = _beginDateNew;

    TimeOfDay v =
        await showTimePicker(context: context, initialTime: _beginTime);

    if (v != null) {
      setState(() {
        _beginTime = v;
        _beginDate = DateTime.utc(_beginDate.year, _beginDate.month,
            _beginDate.day, _beginTime.hour, _beginTime.minute);
      });
    }
  }

  void _chooseEndTime() async {
    TimeOfDay v = await showTimePicker(context: context, initialTime: _endTime);

    if (v != null) {
      setState(() {
        _endTime = v;
        _endTime = v;
        _endDate = DateTime.utc(_beginDate.year, _beginDate.month,
            _beginDate.day, _endTime.hour, _endTime.minute);
        FocusScope.of(context).requestFocus(_focusNode1);
      });
    }
  }

  void _chooseType(controlMyDiary.TypeIs v) {
    setState(() {
      _typeIs = v;
    });
  }

  bool _saveValidator() {
    setState(() {
      _customerValid = _customer.trim().isNotEmpty;
    });
    return _customerValid;
  }

  void _save() async {
    if (_saveValidator() == true) {
      formKey.currentState.save();
      if (await controlMyDiary.edit(
              scaffoldKey,
              widget.dr.documentID,
              _customer,
              _beginDate,
              _endDate,
              _note,
              _amountQuotation,
              _amount,
              _typeIs.index) ==
          true) {
        Navigator.pop(context);
      }
    }
  }
}
