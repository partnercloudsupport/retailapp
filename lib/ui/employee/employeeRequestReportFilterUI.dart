import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/ui/all/selectWithFilterUI.dart';
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class EmployeeRequestReportFilterUI extends StatefulWidget {
  final void Function(String, bool, DateTime, DateTime, bool) _save;
  final String _filterEmployee;
  final bool _filterWithDate;
  final DateTime _filterFromDate;
  final DateTime _filterToDate;
  final bool _filterWithTotalZero;

  EmployeeRequestReportFilterUI(
      this._save,
      this._filterEmployee,
      this._filterWithDate,
      this._filterFromDate,
      this._filterToDate,
      this._filterWithTotalZero);

  @override
  EmployeeRequestReportFilterUIState createState() =>
      EmployeeRequestReportFilterUIState(_filterEmployee, _filterWithDate,
          _filterFromDate, _filterToDate, _filterWithTotalZero);
}

class EmployeeRequestReportFilterUIState
    extends State<EmployeeRequestReportFilterUI>
    with SingleTickerProviderStateMixin {
  String _filterEmployee;
  bool _filterWithDate;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  bool _filterWithTotalZero;

  EmployeeRequestReportFilterUIState(this._filterEmployee, this._filterWithDate,
      this._filterFromDate, this._filterToDate, this._filterWithTotalZero);

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
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildEmployeeChoose(),
              SizedBox(
                height: 8,
              ),
              _buildFilterWithDate(),
              _buildDateFromTo(),
              _buildFilterWithTotalZero(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.filterBy)),
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
            borderSide: BorderSide(color: MyColor.color1)),
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
                    MyLanguage.text(myLanguageItem.chooseAnEmployee),
                    style: MyStyle.style12Color3(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child:
                        Text(_filterEmployee, style: MyStyle.style15Color1()),
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

  Widget _buildFilterWithDate() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _filterWithDate,
            onChanged: (v) => _chooseIsPrivate(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                MyLanguage.text(myLanguageItem.determineThePeriodOfTime),
                style: MyStyle.style16Color1(),
              ),
              Text(
                MyLanguage.text(myLanguageItem.theFilterAppliesOnlyMonthly),
                style: MyStyle.style12Color3Italic(),
              ),
            ],
          )
        ],
      ),
      onTap: _chooseIsPrivate,
    );
  }

  Widget _buildDateFromTo() {
    return _filterWithDate
        ? Row(
            children: <Widget>[
              _buildTime(_chooseFromDate, myLanguageItem.from, _filterFromDate),
              _buildTime(_chooseToDate, myLanguageItem.to, _filterToDate),
            ],
          )
        : SizedBox();
  }

  Widget _buildTime(void Function() save, myLanguageItem _text, DateTime date) {
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
              MyLanguage.text(_text),
              style: MyStyle.style12Color3(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  MyDateTime.formatBy(date, MyDateTimeFormatTypes.ddMMyyyy),
                  style: MyStyle.style15Color1()),
            ),
          ],
        ),
      ),
      onTap: save,
    );
  }

  Widget _buildFilterWithTotalZero() {
    return InkWell(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _filterWithTotalZero,
            onChanged: (v) => _chooseFilterWithTotalZero(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                MyLanguage.text(myLanguageItem.withZeroValues),
                style: MyStyle.style16Color1(),
              ),
              Text(
                MyLanguage.text(myLanguageItem.thisWillApplyToTheDetailsAsWell),
                style: MyStyle.style12Color3Italic(),
              ),
            ],
          )
        ],
      ),
      onTap: _chooseFilterWithTotalZero,
    );
  }

  void _openChooseEmployee() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectWithFilterUI(
                  controlEmployee.getShowInSchedule(),
                  _chooseEmployee,
                  MyLanguage.text(myLanguageItem.chooseAnEmployee),
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

  void _chooseIsPrivate() {
    setState(() {
      _filterWithDate = !_filterWithDate;
    });
  }

  void _chooseFromDate() async {
    DateTime _newDate = await showDatePicker(
      firstDate: DateTime.now().add(Duration(days: -366 * 3)),
      lastDate: DateTime.now().add(Duration(days: 366 * 3)),
      context: context,
      initialDate: _filterFromDate,
    );

    if (_newDate != null) {
      setState(() {
        _filterFromDate = _newDate;
      });
      _chooseToDate();
    }
  }

  void _chooseToDate() async {
    DateTime _newDate = await showDatePicker(
      firstDate: DateTime.now().add(Duration(days: -366 * 3)),
      lastDate: DateTime.now().add(Duration(days: 366 * 3)),
      context: context,
      initialDate: _filterToDate,
    );

    if (_newDate != null) {
      setState(() {
        _filterToDate = _newDate;
      });
    }
  }

  void _chooseFilterWithTotalZero() {
    setState(() {
      _filterWithTotalZero = !_filterWithTotalZero;
    });
  }

  void _save() async {
    widget._save(_filterEmployee, _filterWithDate, _filterFromDate,
        _filterToDate, _filterWithTotalZero);
    Navigator.pop(context);
  }
}
