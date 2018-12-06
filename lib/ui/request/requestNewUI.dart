import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/request/controlRequest.dart'
    as controlRequest;
import 'package:retailapp/control/my/myString.dart' as myString;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/customer/customerSelectUI.dart'
    as customerSelectUI;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:retailapp/control/my/myRegExp.dart' as myRegExp;

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
  DateTime _appointment;
  double _targetPrice = 0;
  String _note = '';

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();
  final FocusNode _focusNode3 = new FocusNode();

  List<DropdownMenuItem<String>> _listEmployee;

  final dateFormat = DateFormat("EEEE, d-MM-yyyy 'at' h:mma");

  @override
  void initState() {
    _fillEmployee();
    super.initState();
  }

  _fillEmployee() {
    _listEmployee = List();
    _listEmployee.add(new DropdownMenuItem(value: '', child: new Text('')));
    Firestore.instance.collection('customer').snapshots().listen((action) {
      action.documents.forEach((f) {
        _listEmployee.add(new DropdownMenuItem(
            value: f.data['name'], child: new Text(f.data['name'])));
      });
    });
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
              _buildTargetPrice()
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
              style: myStyle.dateLevel1(),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Text(
            myLanguage.text(myLanguage.TextIndex.chooseAnEmployee),
            style: myStyle.dateLevel1(),
          ),
          Container(
            decoration: UnderlineTabIndicator(
                borderSide: BorderSide(color: myColor.master)),
            child: DropdownButton(
              isExpanded: true,
              value: _employee,
              items: _listEmployee,
              onChanged: _chooseEmployee,
              style: myStyle.textEdit15(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildrequiredImplementationFormField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      maxLines: 4,
      style: myStyle.textEdit15(),
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.subject)),
      onSaved: (String v) => _requiredImplementation = v,
      focusNode: _focusNode1,
      onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_focusNode2),
    );
  }

  Widget _buildAppointment() {
    return DateTimePickerFormField(
      editable: false,
      format: dateFormat,
      decoration: InputDecoration(
          labelText: myLanguage.text(myLanguage.TextIndex.chooseAppointment)),
      onChanged: _chooseAppointment,
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
            labelText: myLanguage.text(myLanguage.TextIndex.note)),
        onSaved: (String v) => _targetPrice = double.parse(v),
        focusNode: _focusNode2);
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

  void _chooseEmployee(String v) {
    setState(() {
      _employee = v;
    });
  }

  void _chooseAppointment(DateTime v) {
    _appointment = v;
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
              'saleman',
              'type is new') ==
          true) {
        Navigator.pop(_context);
      }
    }
  }
}
