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

class UI extends StatefulWidget {
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {
  BuildContext _context;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _customer = '';
  String _employee = '';
  String _requiredImplementation = '';
  DateTime _appointment = DateTime.now();
  String _salseman = '';
  double _targetPrice = 0;
  String _typeIs = '';

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();

  final dateFormat = DateFormat("EEEE, d-MM-yyyy 'at' h:mma");

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
      myLanguage.text(myLanguage.TextIndex.newRequest),
      style: myStyle.button2(),
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
              _buildrequiredImplementationFormField(),
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
            borderSide: BorderSide(color: myColor.master)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              myLanguage.text(myLanguage.TextIndex.chooseACustomer),
              style: myStyle.dateLevel12(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_customer, style: myStyle.textEdit15()),
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
            borderSide: BorderSide(color: myColor.master)),
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
              child: Text(_employee, style: myStyle.textEdit15()),
            ),
          ],
        ),
      ),
      onTap: _openChooseEmployee,
    );
  }

  Widget _buildrequiredImplementationFormField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: 4,
      style: myStyle.textEdit15(),
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.subject)),
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
          labelText: myLanguage.text(myLanguage.TextIndex.chooseAnAppointment)),
      onChanged: _chooseAppointment,
    );
  }

  Widget _buildSalsemanChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.master)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              myLanguage.text(myLanguage.TextIndex.chooseASalseman),
              style: myStyle.dateLevel12(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(_salseman, style: myStyle.textEdit15()),
            ),
          ],
        ),
      ),
      onTap: _openChooseSalseman,
    );
  }

  Widget _buildTargetPrice() {
    return TextFormField(
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          WhitelistingTextInputFormatter(myRegExp.number1To9999999),
        ],
        initialValue: '0',
        textInputAction: TextInputAction.done,
        style: myStyle.textEdit15(),
        decoration: InputDecoration(
            labelText: myLanguage.text(myLanguage.TextIndex.target)),
        onSaved: (String v) => _targetPrice = double.parse(v),
        focusNode: _focusNode2);
  }

  Widget _buildRequestTypeChoose() {
    return InkWell(
      child: Container(
        decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: myColor.master)),
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
              child: Text(_typeIs, style: myStyle.textEdit15()),
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
            builder: (context) => customerSelectUI.UI(_chooseCustomer)));
  }

  void _chooseCustomer(String v) {
    setState(() {
      _customer = v;
    });
  }

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => selectWithFilterUI.UI(
                controlEmployee.getAll(),
                _chooseEmployee,
                myLanguage.text(myLanguage.TextIndex.chooseAnEmployee))));
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
                controlEmployee.getAll(),
                _chooseSalseman,
                myLanguage.text(myLanguage.TextIndex.chooseASalseman))));
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
                  myLanguage.text(myLanguage.TextIndex.chooseARequestType),
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
    if (_saveValidator() == true) {
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
