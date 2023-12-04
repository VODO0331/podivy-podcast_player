import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/Page/HomePage.dart';
import 'package:podivy/Page/backgound.dart';
import 'package:podivy/Page/mediaPage.dart';
import 'package:podivy/widget/drawer.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), const MediaPage()];
  
  @override
  void initState() {
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: sKey,

      //bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 35.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          useLegacyColorScheme: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox), label: 'media')
          ]),
      drawer: MyDrawer(),

      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
            sKey.currentState?.openDrawer();
          }
        },
        child: Center(
          child: MyBackGround(child: _pages[_currentIndex]),
        ),
      ),
    );
  }
}


