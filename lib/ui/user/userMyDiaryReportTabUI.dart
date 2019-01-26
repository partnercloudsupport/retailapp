import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/user/controlUserMyDiaryMonthlyReport.dart'
    as controlUserMyDiaryMonthlyReport;
import 'package:retailapp/control/my/myStyle.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/myDiary/myDiaryDetailByUserUI.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class UI extends StatefulWidget {
  final String _filterUser;
  final bool _filterWithDate;
  final DateTime _filterFromDate;
  final DateTime _filterToDate;
  final bool _filterWithTotalZero;
  UI(this._filterUser, this._filterWithDate, this._filterFromDate,
      this._filterToDate, this._filterWithTotalZero);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _followUpUserMyDiary = controlUser.drNow.data['name'] +
      ', ' +
      controlUser.drNow.data['followUpUserMyDiary'].toString().toLowerCase() +
      ', ';

  int _filterFromMonthYearNumber = 0;
  int _filterToMonthYearNumber = 0;

  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    controlUser.getMe();
    setState(() {
      _followUpUserMyDiary = controlUser.drNow.data['name'] +
          ', ' +
          controlUser.drNow.data['followUpUserMyDiary']
              .toString()
              .toLowerCase() +
          ', ';

      _filterFromMonthYearNumber =
          MyDateTime.castDateToYearMonthNumber(widget._filterFromDate);
      _filterToMonthYearNumber =
          MyDateTime.castDateToYearMonthNumber(widget._filterToDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlUser.getAllOrderByMyDiaryTotalAmount(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
        if (!v.hasData) return _buildLoading();
        return ListView(
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
        leading: Text(
          dr['myDiaryTotalAmountDF'],
          style: MyStyle.style20Color1(),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dr['name'],
            style: MyStyle.style14Color1(),
          ),
        ),
        children: <Widget>[
          StreamBuilder(
            stream: controlUserMyDiaryMonthlyReport.getOrderByMonthYearNumber(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
              if (!v.hasData) return _buildLoading();

              List<DocumentSnapshot> list = v.data.documents.where((v) {
                if (v.data['userID'].toString() != dr.documentID) return false;

                if (widget._filterWithTotalZero == false &&
                    v.data['amountD'] == 0) return false;

                if (widget._filterWithDate &&
                    (v['monthYearNumber'] < _filterFromMonthYearNumber ||
                        v['monthYearNumber'] > _filterToMonthYearNumber))
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
                    myLanguageItem.monthlySalesReportFromMyDiaries)),
                source: DataRows(list, c, context, dr.documentID,
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

  bool _cardValid(DocumentSnapshot dr) {
    if (dr['isEnabled'] == false) return false;

    if (widget._filterWithTotalZero == false &&
        dr.data['myDiaryTotalAmountD'] == 0) return false;

    if (widget._filterUser.isNotEmpty &&
        dr['name'].toString().toLowerCase() != widget._filterUser.toLowerCase())
      return false;

    if ((_followUpUserMyDiary
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
  final String _userID;
  final bool _filterWithTotalZero;
  DataRows(this.list, this._rowCount, this._context, this._userID,
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
                  builder: (context) => MyDiaryDetailByUserUI(_userID,
                      list[i].data['monthYearNumber'], _filterWithTotalZero)));
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
