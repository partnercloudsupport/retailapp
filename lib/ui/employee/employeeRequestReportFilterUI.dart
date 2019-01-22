import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/all/selectWithFilterUI.dart' as selectWithFilterUI;
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

String _filterEmployee = '';
bool _filterWithDate = false;
DateTime _filterFromDate = DateTime.now();
DateTime _filterToDate = DateTime.now();
bool _filterWithTotalZero = true;

class UI extends StatefulWidget {
  final void Function(String, bool, DateTime, DateTime, bool) _save;

  UI(
      this._save,
      String filterEmployee,
      bool filterWithDate,
      DateTime filterFromDate,
      DateTime filterToDate,
      bool filterWithTotalZero) {
    _filterEmployee = filterEmployee;
    _filterWithDate = filterWithDate;
    _filterFromDate = filterFromDate;
    _filterToDate = filterToDate;
    _filterWithTotalZero = filterWithTotalZero;
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
      title: Text(myLanguage.text(myLanguage.item.filterBy)),
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
            borderSide: BorderSide(color: myColor.color1)),
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
                    myLanguage.text(myLanguage.item.chooseAnEmployee),
                    style: myStyle.style12Color3(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child:
                        Text(_filterEmployee, style: myStyle.style15Color1()),
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
                myLanguage.text(myLanguage.item.determineThePeriodOfTime),
                style: myStyle.style16Color1(),
              ),
              Text(
                myLanguage.text(myLanguage.item.theFilterAppliesOnlyMonthly),
                style: myStyle.style12Color3Italic(),
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
              _buildTime(
                  _chooseFromDate, myLanguage.item.from, _filterFromDate),
              _buildTime(_chooseToDate, myLanguage.item.to, _filterToDate),
            ],
          )
        : SizedBox();
  }

  Widget _buildTime(
      void Function() save, myLanguage.item _text, DateTime date) {
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
              child: Text(myDateTime.formatBy(date, myDateTime.Types.ddMMyyyy),
                  style: myStyle.style15Color1()),
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
                myLanguage.text(myLanguage.item.withZeroValues),
                style: myStyle.style16Color1(),
              ),
              Text(
                myLanguage
                    .text(myLanguage.item.thisWillApplyToTheDetailsAsWell),
                style: myStyle.style12Color3Italic(),
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
            builder: (context) => selectWithFilterUI.UI(
                  controlEmployee.getShowInSchedule(),
                  _chooseEmployee,
                  myLanguage.text(myLanguage.item.chooseAnEmployee),
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
