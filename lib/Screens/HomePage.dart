import 'package:e_commerce_app/Services/FirebaseAuthServices.dart';
import 'package:e_commerce_app/Tabs/HomeTab.dart';
import 'package:e_commerce_app/Tabs/SavedTab.dart';
import 'package:e_commerce_app/Tabs/SearchTab.dart';
import 'package:e_commerce_app/Widgets/BottomTabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: [HomeTab(), SearchTab(), SavedTab()],
            ),
          ),
          BootomTabs(
              selectedTab: _selectedTab,
              tabPressed: (num) {
                _tabPageController.animateToPage(num,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic);
              }),
        ],
      ),
    );
  }
}
