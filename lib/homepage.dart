import 'package:citypetro/dashboard.dart';
import 'package:citypetro/settings.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentTabIndex=0;
  @override
  Widget build(BuildContext context) {
    final _kTabPages=<Widget>[
      Dashboard(),
      Settings()
    ];
    final _kBottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Home')),
      BottomNavigationBarItem(icon: Icon(Icons.settings),title: Text('Settings')),
    ];
    assert(_kTabPages.length==_kBottomNavBarItems.length);
    final bottomNavBar=BottomNavigationBar(
      items: _kBottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
        onTap: (int index){
        setState(() {
          _currentTabIndex=index;
        });
        },
    );
    return Scaffold(

      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
