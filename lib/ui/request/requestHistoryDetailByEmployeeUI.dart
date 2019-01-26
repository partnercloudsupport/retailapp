import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/request/controlRequestHistory.dart'
    as controlRequestHistory;
import 'package:retailapp/control/my/myLanguage.dart';


class UI extends StatefulWidget {
  final String filterByEmployeeID;
  final int _filterMonthYearNumber;
  final bool _filterWithTotalZero;
  UI(this.filterByEmployeeID, this._filterMonthYearNumber,
      this._filterWithTotalZero);
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildList(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(MyLanguage.text(myLanguageItem.requests)),
    );
  }

  Widget _buildList() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: controlRequestHistory.getAllOrderByamount(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
            if (!v.hasData) return _buildLoading();

            List<DocumentSnapshot> list = v.data.documents.where((v) {
              if (v.data['salsemanID'].toString() != widget.filterByEmployeeID)
                return false;

              if (widget._filterWithTotalZero == false && v.data['amount'] == 0)
                return false;

              if (v.data['statusIs'] != 4) return false;

              if (MyDateTime.castDateToYearMonthNumber(v.data['endIn']) !=
                  widget._filterMonthYearNumber) return false;

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
              rowsPerPage: c <= 8 ? c : 8,
              header: Text(MyLanguage
                  .text(myLanguageItem.monthlySalesReportFromRequests)),
              source: DataRows(list, c),
              columns: <DataColumn>[
                DataColumn(
                    label: Text(MyLanguage.text(myLanguageItem.customer))),
                DataColumn(label: Text(MyLanguage.text(myLanguageItem.date))),
                DataColumn(
                    label: Text(MyLanguage.text(myLanguageItem.amount))),
                DataColumn(
                    label: Text(
                        MyLanguage.text(myLanguageItem.textToBeImplemented))),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DataRows extends DataTableSource {
  final List<DocumentSnapshot> list;
  final int _rowCount;
  DataRows(this.list, this._rowCount);

  @override
  DataRow getRow(int i) {
    return DataRow(cells: [
      DataCell(Text(
        list[i].data['customer'],
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        MyDateTime.formatBy(list[i].data['endIn'], MyDateTimeFormatTypes.ddMMyyyy),
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountF'],
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['requiredImplementation'],
        style: MyStyle.style14Color1(),
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
