import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:podivy/Page/homePage.dart';
import 'package:podivy/widget/backgound.dart';
import 'package:podivy/Page/mediaPage.dart';
import 'package:podivy/widget/drawer.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  static const int totalPage = 2;
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  int _currentPage = 0;
  static const List<String> names = [
    'Home',
    'Media',
  ];

  List<IconData> icons = [
    Icons.home_rounded,
    Icons.all_inbox,
  ];

  final List<Widget> _pages = [
    const HomePage(),
    const MediaPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      body: BottomBarPageTransition(
        builder: (_, index) => _getBody(index),
        currentIndex: _currentPage,
        totalLength: 2,
        transitionType: TransitionType.circular,
        transitionDuration: const Duration(milliseconds: 500),
        transitionCurve: Curves.easeInOut,
      ),
      bottomNavigationBar: _getBottomBar(),
      drawer: const MyDrawer(),
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF141513),
      iconSize: 35.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentPage,
      onTap: (index) {
        _currentPage = index;
        setState(() {});
      },
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        totalPage,
        (index) => BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: names[index],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
            sKey.currentState?.openDrawer();
          }
        },
        child: MyBackGround(child: _pages[index]));
  }
}
