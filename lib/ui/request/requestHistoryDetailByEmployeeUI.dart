import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/request/controlRequestHistory.dart'
    as controlRequestHistory;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

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
      textDirection: myLanguage.rtl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildList(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(myLanguage.text(myLanguage.item.requests)),
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

              if (myDateTime.castDateToYearMonthNumber(v.data['endIn']) !=
                  widget._filterMonthYearNumber) return false;

              return true;
            }).toList();

            int c = list.length;
            if (c == 0)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  myLanguage.text(myLanguage.item.thereAreNoData) + '...',
                  style: myStyle.style12Color3(),
                ),
              );

            return PaginatedDataTable(
              rowsPerPage: c <= 8 ? c : 8,
              header: Text(myLanguage
                  .text(myLanguage.item.monthlySalesReportFromRequests)),
              source: DataRows(list, c),
              columns: <DataColumn>[
                DataColumn(
                    label: Text(myLanguage.text(myLanguage.item.customer))),
                DataColumn(label: Text(myLanguage.text(myLanguage.item.date))),
                DataColumn(
                    label: Text(myLanguage.text(myLanguage.item.amount))),
                DataColumn(
                    label: Text(
                        myLanguage.text(myLanguage.item.textToBeImplemented))),
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
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        myDateTime.formatBy(list[i].data['endIn'], myDateTime.Types.ddMMyyyy),
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountF'],
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['requiredImplementation'],
        style: myStyle.style14Color1(),
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
