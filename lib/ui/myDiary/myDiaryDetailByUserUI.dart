import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/ui/mapGoogle/mapGoogleViewUI.dart' as mapGoogleViewUI;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLanguage.dart' as myLanguage;
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/control/my/mySnackBar.dart' as mySnackBar;
import 'package:retailapp/control/my/mySuperTooltip.dart' as mySuperTooltip;
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

class UI extends StatefulWidget {
  final String filterByUesrID;
  final int _filterMonthYearNumber;
  final bool _filterWithTotalZero;
  UI(this.filterByUesrID, this._filterMonthYearNumber,
      this._filterWithTotalZero);
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    controlUser.getMe();
  }

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
      title: Text(myLanguage.text(myLanguage.item.myDiaries)),
    );
  }

  Widget _buildList() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: controlMyDiary.getAllOrderByamount(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
            if (!v.hasData) return _buildLoading();

            List<DocumentSnapshot> list = v.data.documents.where((v) {
              if (v.data['userID'].toString() != widget.filterByUesrID)
                return false;
              if (widget._filterWithTotalZero == false && v.data['amount'] == 0)
                return false;

              if (myDateTime.castDateToYearMonthNumber(v.data['beginDate']) !=
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
                  .text(myLanguage.item.monthlySalesReportFromMyDiaries)),
              source: DataRows(list, c, context),
              columns: <DataColumn>[
                DataColumn(
                    label: Text(myLanguage.text(myLanguage.item.customer))),
                DataColumn(
                    label: Text(myLanguage.text(myLanguage.item.duration))),
                DataColumn(label: Text(myLanguage.text(myLanguage.item.total))),
                DataColumn(
                    label: Text(myLanguage.text(myLanguage.item.viewLocation))),
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
  final BuildContext _context;
  DataRows(this.list, this._rowCount, this._context);

  @override
  DataRow getRow(int i) {
    return DataRow(cells: [
      DataCell(Text(
        list[i].data['customer'],
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['durationHourF'],
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountF'].toString(),
        style: myStyle.style14Color1(),
      )),
      DataCell(IconButton(
        icon: Icon(
          Icons.location_on,
          color: myColor.color1,
        ),
        onPressed: () => _viewMap(list[i]),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rowCount;

  @override
  int get selectedRowCount => 0;

  void _viewMap(DocumentSnapshot dr) async {
    if (controlUser.isAdmin == false) {
      mySuperTooltip.show4(
          _context,
          myLanguage.text(
              myLanguage.item.thisProcessIsSpecificOnlyToTheAdministrator));
      return;
    }

    DocumentSnapshot drCustomer;

    drCustomer =
        await controlCustomer.getDataRow(dr.data['customerID'].toString());
    if (drCustomer.exists == false) {
      mySnackBar.showInHomePage1(
          myLanguage.text(myLanguage.item.theCustomerYouWantIsNotFound));
      return;
    }

    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (BuildContext context) => mapGoogleViewUI.UI(
                drCustomer.data['name'],
                drCustomer.data['phones'],
                drCustomer.data['mapLocation'])));
  }
}
