import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myLanguage.dart';
import 'package:retailapp/ui/all/dashboard/myCraphLine.dart';

class ReportRequestDashboardUI extends StatefulWidget {
  _ReportRequestDashboardUIState createState() =>
      _ReportRequestDashboardUIState();
}

class _ReportRequestDashboardUIState extends State<ReportRequestDashboardUI> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: MyLanguage.rtl(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: MyGraphLine(),
      ),
    );
  }
}
