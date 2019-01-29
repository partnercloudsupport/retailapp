import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/employee/controlEmployeeRequestMonthlyReport.dart'
    as controlEmployeeRequestMonthlyReport;
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myString.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/request/requestHistoryDetailByEmployeeUI.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class EmployeeRequestReportTabUI extends StatefulWidget {
  final String _filterEmployee;
  final bool _filterWithDate;
  final int _filterFromMonthYearNumber;
  final int _filterToMonthYearNumber;
  final bool _filterWithTotalZero;

  EmployeeRequestReportTabUI(
      this._filterEmployee,
      this._filterWithDate,
      this._filterFromMonthYearNumber,
      this._filterToMonthYearNumber,
      this._filterWithTotalZero);

  @override
  EmployeeRequestReportTabUIState createState() =>
      EmployeeRequestReportTabUIState();
}

class EmployeeRequestReportTabUIState extends State<EmployeeRequestReportTabUI>
    with SingleTickerProviderStateMixin {
  String _followUpEmployeeRequest = controlUser
          .drNow.data['followUpEmployeeRequest']
          .toString()
          .toLowerCase() +
      ', ';

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    controlUser.getMe();
    setState(() {
      _followUpEmployeeRequest = controlUser
              .drNow.data['followUpEmployeeRequest']
              .toString()
              .toLowerCase() +
          ', ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTotal(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal() {
    return FutureBuilder(
      future: controlEmployeeRequestMonthlyReport.getAllTotal(),
      builder: (BuildContext context, AsyncSnapshot<double> v) {
        return Card(
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Text(
                  MyLanguage.text(myLanguageItem.total) + ': ',
                  style: MyStyle.style20Color1(),
                ),
                v.data == null
                    ? _buildLoading()
                    : Text(
                        MyString.formatCurrencyD(v.data),
                        style: MyStyle.style26Color1(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlEmployee.getAllOrderByTotalAmountRequestD(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildLoading();
        return ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 70),
          children: v.data.documents.where((v) {
            return _cardValid(v);
          }).map((DocumentSnapshot dr) {
            return _buildCard(dr);
          }).toList(),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCard(DocumentSnapshot dr) {
    return Card(
      child: ExpansionTile(
        leading: _buildEmployeeTotal(dr),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dr['name'],
            style: MyStyle.style14Color1(),
          ),
        ),
        children: <Widget>[
          StreamBuilder(
            stream:
                controlEmployeeRequestMonthlyReport.getOrderByMonthYearNumber(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
              if (!v.hasData) return _buildLoading();

              List<DocumentSnapshot> list = v.data.documents.where((v) {
                if (v.data['employeeID'].toString() != dr.documentID)
                  return false;

                if (widget._filterWithTotalZero == false &&
                    v.data['amountD'] == 0) return false;

                if (widget._filterWithDate &&
                    (v['monthYearNumber'] < widget._filterFromMonthYearNumber ||
                        v['monthYearNumber'] > widget._filterToMonthYearNumber))
                  return false;

                return true;
              }).toList();

              int c = list.length;
              if (c == 0)
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    MyLanguage.text(myLanguageItem.thereAreNoData) + '...',
                    style: MyStyle.style12Color3(),
                  ),
                );

              return PaginatedDataTable(
                rowsPerPage: c <= 3 ? c : 3,
                header: Text(MyLanguage.text(
                    myLanguageItem.monthlySalesReportFromRequests)),
                source: DataRows(
                    list,
                    c,
                    context,
                    widget._filterWithDate,
                    widget._filterFromMonthYearNumber,
                    widget._filterToMonthYearNumber,
                    widget._filterWithTotalZero),
                columns: <DataColumn>[
                  DataColumn(
                      label: Text(MyLanguage.text(myLanguageItem.month))),
                  DataColumn(
                      label: Text(MyLanguage.text(myLanguageItem.count))),
                  DataColumn(
                      label: Text(MyLanguage.text(myLanguageItem.total))),
                  DataColumn(
                      label: Text(MyLanguage.text(myLanguageItem.detail))),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeTotal(DocumentSnapshot dr) {
    return widget._filterWithDate
        ? FutureBuilder(
            future: controlEmployeeRequestMonthlyReport.getTotalOfEmployee(
                int.parse(dr.documentID),
                widget._filterFromMonthYearNumber,
                widget._filterToMonthYearNumber),
            builder: (BuildContext context, AsyncSnapshot<double> v) {
              return v.data == null
                  ? _buildLoading()
                  : Text(
                      MyString.formatCurrencyD(v.data),
                      style: MyStyle.style26Color1(),
                    );
            },
          )
        : Text(
            dr['totalAmountRequestDF'],
            style: MyStyle.style20Color1(),
          );
  }

  bool _cardValid(DocumentSnapshot dr) {
    if (dr['showInSchedule'] == false) return false;

    if (widget._filterWithTotalZero == false &&
        dr.data['totalAmountRequestD'] == 0) return false;

    if (widget._filterEmployee.isNotEmpty &&
        dr['name'].toString().toLowerCase() !=
            widget._filterEmployee.toLowerCase()) return false;

    if ((_followUpEmployeeRequest
                .contains(dr['name'].toString().toLowerCase() + ',') ||
            controlUser.drNow.data['name'].toString().toLowerCase() ==
                'admin') ==
        false) return false;

    return true;
  }
}

class DataRows extends DataTableSource {
  final List<DocumentSnapshot> list;
  final int _rowCount;
  final BuildContext _context;
  final bool _filterWithDate;
  final int _filterFromMonthYearNumber;
  final int _filterToMonthYearNumber;
  final bool _filterWithTotalZero;
  DataRows(
      this.list,
      this._rowCount,
      this._context,
      this._filterWithDate,
      this._filterFromMonthYearNumber,
      this._filterToMonthYearNumber,
      this._filterWithTotalZero);

  @override
  DataRow getRow(int i) {
    return DataRow(cells: [
      DataCell(Text(
        list[i].data['monthYearF'],
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['countIs'].toString(),
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountDF'],
        style: MyStyle.style14Color1(),
      )),
      DataCell(IconButton(
        icon: Icon(
          Icons.list,
          color: MyColor.color1,
        ),
        onPressed: () {
          Navigator.push(
              _context,
              MaterialPageRoute(
                  builder: (context) => RequestHistoryDetailByEmployeeUI(
                      list[i].data['employeeID'].toString(),
                      list[i].data['monthYearNumber'],
                      _filterWithTotalZero)));
        },
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rowCount;

  @override
  int get selectedRowCount => 0;
}
