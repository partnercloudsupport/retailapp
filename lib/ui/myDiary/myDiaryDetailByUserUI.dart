import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myDateTime.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:retailapp/control/my/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailapp/control/myDiary/controlMyDiary.dart'
    as controlMyDiary;
import 'package:retailapp/ui/GoogleMap/GoogleMapViewUI.dart';
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/control/customer/controlCustomer.dart'
    as controlCustomer;
import 'package:retailapp/control/my/mySnackBar.dart';
import 'package:retailapp/control/my/mySuperTooltip.dart';
import 'package:retailapp/control/liveVersion/controlLiveVersion.dart'
    as controlLiveVersion;

class MyDiaryDetailByUserUI extends StatefulWidget {
  final String filterByUesrID;
  final int _filterMonthYearNumber;
  final bool _filterWithTotalZero;
  MyDiaryDetailByUserUI(this.filterByUesrID, this._filterMonthYearNumber,
      this._filterWithTotalZero);
  @override
  MyDiaryDetailByUserUIState createState() => MyDiaryDetailByUserUIState();
}

class MyDiaryDetailByUserUIState extends State<MyDiaryDetailByUserUI> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    controlLiveVersion.checkupVersion(context);
    super.initState();
    controlUser.getMe();
  }

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
      title: Text(MyLanguage.text(myLanguageItem.myDiaries)),
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

              if (MyDateTime.castDateToYearMonthNumber(v.data['beginDate']) !=
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
                  .text(myLanguageItem.monthlySalesReportFromMyDiaries)),
              source: DataRows(list, c, context),
              columns: <DataColumn>[
                DataColumn(
                    label: Text(MyLanguage.text(myLanguageItem.customer))),
                DataColumn(
                    label: Text(MyLanguage.text(myLanguageItem.duration))),
                DataColumn(label: Text(MyLanguage.text(myLanguageItem.total))),
                DataColumn(
                    label: Text(MyLanguage.text(myLanguageItem.viewLocation))),
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
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['durationHourF'],
        style: MyStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountF'].toString(),
        style: MyStyle.style14Color1(),
      )),
      DataCell(IconButton(
        icon: Icon(
          Icons.location_on,
          color: MyColor.color1,
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
      MySuperTooltip.show4(
          _context,
          MyLanguage.text(
              myLanguageItem.thisProcessIsSpecificOnlyToTheAdministrator));
      return;
    }

    DocumentSnapshot drCustomer;

    drCustomer =
        await controlCustomer.getDataRow(dr.data['customerID'].toString());
    if (drCustomer.exists == false) {
      MySnackBar.showInHomePage1(
          MyLanguage.text(myLanguageItem.theCustomerYouWantIsNotFound));
      return;
    }

    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (BuildContext context) => GoogleMapViewUI(
                drCustomer.data['name'],
                drCustomer.data['phones'],
                drCustomer.data['mapLocation'])));
  }
}
