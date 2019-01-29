import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myDouble.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myRegExp.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/ui/customer/customerSelectUI.dart';

class MyDiaryNewUI extends StatefulWidget {
  _MyDiaryNewUIState createState() => _MyDiaryNewUIState();
}

class _MyDiaryNewUIState extends State<MyDiaryNewUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        key: _scaffoldKey,
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
      MyLanguage.text(myLanguageItem.newADailyEvent),
      style: MyStyle.style18Color2(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildCustomerChoose(),
              _buildTimeFromTo(),
              _buildNote(),
              _buildAmountQuotation(),
              // _buildAmount(),
              _buildTypeIs(),
            ],
          )),
    );
  }

  Widget _buildCustomerChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: MyColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('*', style: MyStyle.style16Color4()),
                SizedBox(
                  width: 7,
                ),
                Text(
                  MyLanguage.text(myLanguageItem.chooseACustomer),
                  style: MyStyle.style12Color3(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_customer, style: MyStyle.style15Color1()),
            ),
            _customerValid
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                        MyLanguage.text(myLanguageItem.youMustChooseAValue),
                        style: MyStyle.style14Color4()))
          ],
        ),
      ),
      onTap: _openChooseCustomer,
    );
  }

  Widget _buildTimeFromTo() {
    return Row(
      children: <Widget>[
        _buildTime(_chooseBeginTime, myLanguageItem.from, _beginTime),
        _buildTime(_chooseEndTime, myLanguageItem.to, _endTime),
      ],
    );
  }

  Widget _buildTime(
      void Function() save, myLanguageItem _text, TimeOfDay time) {
    return InkWell(
      child: Container(
        width: (MediaQuery.of(context).size.width - 20) / 2,
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: MyColor.color1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              MyLanguage.text(_text) +
                  ' ' +
                  MyDateTime.formatDateAndShort(_beginDate),
              style: MyStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  MyDateTime.formatTimeOfDayBy(
                      time, MyDateTimeFormatTypes.hhmma),
                  style: MyStyle.style15Color1()),
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
      style: MyStyle.style15Color1(),
      decoration: InputDecoration(
          labelText: MyLanguage.text(myLanguageItem.weTalkedAbout)),
      onSaved: (String v) => _note = v,
      focusNode: _focusNode1,
    );
  }

  Widget _buildAmountQuotation() {
    return TextFormField(
        textInputAction: TextInputAction.next,
        initialValue: '0',
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(MyRegExp.number1To9999999),
        ],
        style: MyStyle.style15Color1(),
        decoration: InputDecoration(
            prefix: Text(r'$ ', style: MyStyle.style14Color1()),
            suffix: Text(
              'USD',
              style: MyStyle.style14Color1(),
            ),
            labelText: MyLanguage.text(myLanguageItem.amountOfQuotation)),
        onFieldSubmitted: (String v) =>
            FocusScope.of(context).requestFocus(_focusNode2),
        onSaved: (String v) => _amountQuotation = MyDouble.toMe(v));
  }

  Widget _buildAmount() {
    return TextFormField(
        initialValue: '0',
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(MyRegExp.number1To9999999),
        ],
        style: MyStyle.style15Color1(),
        decoration: InputDecoration(
            prefix: Text(r'$ ', style: MyStyle.style14Color1()),
            suffix: Text(
              'USD',
              style: MyStyle.style14Color1(),
            ),
            labelText: MyLanguage.text(myLanguageItem.resultingAmount)),
        focusNode: _focusNode2,
        onSaved: (String v) => _amount = MyDouble.toMe(v));
  }

  Widget _buildTypeIs() {
    return Container(
      decoration:
          UnderlineTabIndicator(borderSide: BorderSide(color: MyColor.color1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            MyLanguage.text(myLanguageItem.type),
            style: MyStyle.style12Color3(),
          ),
          Wrap(
            children: <Widget>[
              _buildTypeItem(MyLanguage.text(myLanguageItem.showroom),
                  controlMyDiary.TypeIs.showroom),
              _buildTypeItem(MyLanguage.text(myLanguageItem.outgoingCall),
                  controlMyDiary.TypeIs.outgoingCall),
              _buildTypeItem(MyLanguage.text(myLanguageItem.visitCustomer),
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
          controlMyDiary.buildType(valueIs.index, MyColor.color1),
          Text(
            _text,
            style: MyStyle.style15Color1(),
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
            builder: (context) => CustomerSelectUI(
                  _chooseCustomer,
                  withNew: true,
                )));
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
      _formKey.currentState.save();
      if (await controlMyDiary.save(_scaffoldKey, _customer, _beginDate,
              _endDate, _note, _amountQuotation, _amount, _typeIs.index) ==
          true) {
        Navigator.pop(context);
      }
    }
  }
}
