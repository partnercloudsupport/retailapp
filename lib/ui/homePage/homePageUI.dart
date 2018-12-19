import 'package:flutter/material.dart';
import 'package:retailapp/ui/callerLog/callerLogListUI.dart' as callerLogListUI;
import 'package:retailapp/ui/customer/customerListUI.dart' as customerListUI;
import 'package:retailapp/ui/request/requestListUI.dart' as requestListUI;

int _currentIndex = 1;

class UI extends StatefulWidget {
  UI(_currentIndex);

  @override
  UIState createState() => UIState();
}

class UIState extends State<UI> with SingleTickerProviderStateMixin {
  TabController _tabController;

  Widget _ui = callerLogListUI.UI();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    openUI(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _ui,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (int i) => openUI(i),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.contacts,
            ),
            title: Text('Contacts')),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_from_queue,
            ),
            title: Text('Request')),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.call,
            ),
            title: Text('Caller Log')),
      ],
    );
  }

  void openUI(int i) {
    setState(() {
      _currentIndex = i;

      switch (_currentIndex) {
        case 0:
          _ui = customerListUI.UI();
          break;
        case 1:
          _ui = requestListUI.UI();
          break;
        case 2:
          _ui = callerLogListUI.UI();
          break;

        default:
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
