import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myStyle.dart' as myStyle;
import 'package:retailapp/control/permission/controlPermission.dart'
    as controlPermission;
import 'package:retailapp/control/user/controlUser.dart' as controlUser;
import 'package:retailapp/control/user/controlUserMyDiaryMonthlyReport.dart'
    as controlUserMyDiaryMonthlyReport;
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myDateTime.dart' as myDateTime;

class UI extends StatefulWidget {
  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  String _followUpUserMyDiary = controlUser.drNow.data['name'] +
      ', ' +
      controlUser.drNow.data['followUpUserMyDiary'].toString().toLowerCase() +
      ', ';

  @override
  void initState() {
    super.initState();
    controlUser.getMe();
    controlPermission.getMe();
    setState(() {
      _followUpUserMyDiary = controlUser.drNow.data['name'] +
          ', ' +
          controlUser.drNow.data['followUpUserMyDiary']
              .toString()
              .toLowerCase() +
          ', ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controlUser.getAllOrderByTotalAmountRequestD(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpansionTile(
            leading: Text(
              dr['myDiaryTotalAmountDF'],
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
              Container(
                height: 150,
                child: StreamBuilder<QuerySnapshot>(
                  stream: controlUserMyDiaryMonthlyReport
                      .getOrderByMonthYearNumber(),
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> v) {
                    if (!v.hasData) return _buildLoading();
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2, crossAxisCount: 3),
                      padding: EdgeInsets.only(bottom: 70),
                      children: v.data.documents.where((v) {
                        return (v.data['userID'].toString() ==
                            dr.documentID);
                      }).map((DocumentSnapshot dr) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(color: myColor.color1),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    topLeft: Radius.circular(50))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  dr['amountDF'] +
                                      ' \\ ' +
                                      dr.data['countIs'].toString(),
                                  style: myStyle.style15Color1(),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  myDateTime.shortMMYYYY(dr.data['monthYearF']),
                                  style: myStyle.style12Color3Italic(),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  bool _cardValid(DocumentSnapshot dr) {
    if ((_followUpUserMyDiary
                .contains(dr['user'].toString().toLowerCase() + ',') ||
            controlUser.drNow.data['name'].toString().toLowerCase() ==
                'admin') ==
        false) return false;

    return true;
  }
}
