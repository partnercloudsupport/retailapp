import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/customer/customerSelectUI.dart'
    as customerSelectUI;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:retailapp/control/my/myRegExp.dart' as myRegExp;
import 'package:retailapp/ui/all/selectWithFilterUI.dart' as selectWithFilterUI;
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/request/controlRequestType.dart'
    as controlRequestType;
import 'package:retailapp/control/my/mydouble.dart' as mydouble;
import 'package:retailapp/control/my/myString.dart' as myString;
import 'package:retailapp/control/my/myInternetStatus.dart' as myInternetStatus;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

String _requiredImplementation = '';
String _customer = '';
double _targetPrice = 0;

class UI extends StatefulWidget {
  UI(
      {String customer = '',
      String requiredImplementation = '',
      double targetPrice = 0}) {
    if (requiredImplementation.trim().isNotEmpty)
      _requiredImplementation = requiredImplementation;
    if (customer.trim().isNotEmpty) _customer = customer;
    _targetPrice = targetPrice;
  }
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext _context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _employee = '';
  DateTime _appointment = DateTime.now();
  String _salseman = '';

  String _typeIs = '';

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();

  final dateFormat = DateFormat("EEEE, d-MM-yyyy 'at' h:mma");

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
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
      myLanguage.text(myLanguage.item.newRequest),
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
              _buildEmployeeChoose(),
              _buildrequiredImplementation(),
              _buildAppointment(),
              _buildSalsemanChoose(),
              _buildTargetPrice(),
              _buildRequestTypeChoose(),
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
              child: Text(_customer, style: myStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: _openChooseCustomer,
    );
  }

  Widget _buildEmployeeChoose() {
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
              child: Text(_employee, style: myStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: _openChooseEmployee,
    );
  }

  Widget _buildrequiredImplementation() {
    return TextFormField(
      initialValue: _requiredImplementation,
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: myStyle.style15Color1(),
      decoration:
          InputDecoration(labelText: myLanguage.text(myLanguage.item.subject)),
      onSaved: (String v) => _requiredImplementation = v,
      focusNode: _focusNode1,
    );
  }

  Widget _buildAppointment() {
    return DateTimePickerFormField(
      initialValue: _appointment,
      editable: false,
      format: dateFormat,
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.item.chooseAnAppointment)),
      onChanged: _chooseAppointment,
    );
  }

  Widget _buildSalsemanChoose() {
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
              myLanguage.text(myLanguage.item.chooseASalseman),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_salseman, style: myStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: _openChooseSalseman,
    );
  }

  Widget _buildTargetPrice() {
    return TextFormField(
        initialValue: myString.formatNumber(_targetPrice),
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(myRegExp.number1To9999999),
        ],
        textInputAction: TextInputAction.done,
        style: myStyle.style15Color1(),
        decoration:
            InputDecoration(labelText: myLanguage.text(myLanguage.item.target)),
        onSaved: (String v) => _targetPrice = mydouble.to(v),
        focusNode: _focusNode2);
  }

  Widget _buildRequestTypeChoose() {
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
              myLanguage.text(myLanguage.item.chooseARequestType),
              style: myStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_typeIs, style: myStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: _openChooseRequestType,
    );
  }

  void _openChooseCustomer() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => customerSelectUI.UI(
                  _chooseCustomer,
                  withNew: true,
                )));
  }

  void _chooseCustomer(String v) {
    setState(() {
      _customer = v;
      print(v);
      print(_customer);
    });
  }

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlEmployee.getShowInSchedule(),
                  _chooseEmployee,
                  myLanguage.text(myLanguage.item.chooseAnEmployee),
                  autofocus: false,
                )));
  }

  void _chooseEmployee(String v) {
    setState(() {
      _employee = v;
    });
  }

  void _chooseAppointment(DateTime v) {
    setState(() {
      _appointment = v;
    });
  }

  void _openChooseSalseman() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlEmployee.getShowInSchedule(),
                  _chooseSalseman,
                  myLanguage.text(myLanguage.item.chooseASalseman),
                  autofocus: false,
                )));
  }

  void _chooseSalseman(String v) {
    setState(() {
      _salseman = v;
    });
  }

  void _openChooseRequestType() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                  controlRequestType.getAll(),
                  _chooseRequestType,
                  myLanguage.text(myLanguage.item.chooseARequestType),
                  autofocus: false,
                )));
  }

  void _chooseRequestType(String v) {
    setState(() {
      _typeIs = v;
    });
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
    if (_saveValidator() == true &&
        await myInternetStatus.checkInternetWithTip(context) == true) {
      if (await controlRequest.save(
              scaffoldKey,
              _customer,
              _employee,
              _requiredImplementation,
              _appointment,
              _targetPrice,
              3,
              _salseman,
              _typeIs) ==
          true) {
        Navigator.pop(_context);
      }
    }
  }
}
