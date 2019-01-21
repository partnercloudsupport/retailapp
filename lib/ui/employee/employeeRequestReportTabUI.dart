import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;
import 'package:retailapp/control/employee/controlEmployee.dart'
    as controlEmployee;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/employee/controlEmployeeRequestMonthlyReport.dart'
    as controlEmployeeRequestMonthlyReport;
import 'package:retailapp/control/my/myColor.dart' as myColor;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _followUpEmployeeRequest = controlUser
          .drNow.data['followUpEmployeeRequest']
          .toString()
          .toLowerCase() +
      ', ';

  @override
  void initState() {
    super.initState();
    controlUser.getMe();
    controlPermission.getMe();
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
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlEmployee.getAllOrderByTotalAmountRequestD(),
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
          dr['totalAmountRequestDF'],
          style: myStyle.style20Color1(),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dr['name'],
            style: myStyle.style14Color1(),
          ),
        ),
        children: <Widget>[
          StreamBuilder(
            stream:
                controlEmployeeRequestMonthlyReport.getOrderByMonthYearNumber(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
              if (!v.hasData) return Text('Loading...');

              List<DocumentSnapshot> list = v.data.documents.where((v) {
                return (v.data['employeeID'].toString() == dr.documentID);
              }).toList();

              int c = list.length;
              if (c == 0)
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No data...',
                    style: myStyle.style12Color3(),
                  ),
                );

              return PaginatedDataTable(
                rowsPerPage: c <= 3 ? c : 3,
                header: Text('Request sales report'),
                source: DataRows(list, c),
                columns: <DataColumn>[
                  DataColumn(label: Text('Month')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Detail')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool _cardValid(DocumentSnapshot dr) {
    if ((_followUpEmployeeRequest
                .contains(dr['name'].toString().toLowerCase() + ',') ||
            controlUser.drNow.data['name'].toString().toLowerCase() ==
                'admin') ==
        false) return false;

    if (dr['showInSchedule'] == false) return false;

    return true;
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
        list[i].data['monthYearF'],
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['countIs'].toString(),
        style: myStyle.style14Color1(),
      )),
      DataCell(Text(
        list[i].data['amountDF'],
        style: myStyle.style14Color1(),
      )),
      DataCell(IconButton(
        icon: Icon(
          Icons.list,
          color: myColor.color1,
        ),
        onPressed: () => {},
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
