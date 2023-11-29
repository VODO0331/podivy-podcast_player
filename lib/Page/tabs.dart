import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/Page/HomePage.dart';
import 'package:podivy/Page/backgound.dart';
import 'package:podivy/Page/media.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), MediaPage()];
  
  @override
  void initState() {
    super.initState();
  }
  Widget drawer() {
  return Drawer(
      child: Stack(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          "images/drawer/vine1.png",
          width: 200.0.w,
          height: 200.0.h,
          fit: BoxFit.cover,
          color: const Color.fromARGB(255, 146, 146, 146),
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Image.asset(
          "images/drawer/vine2.png",
          width: 150.0.w,
          height: 150.0.h,
          fit: BoxFit.cover,
          color: const Color.fromARGB(255, 146, 146, 146),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90.h,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 26.h,
              child: CircleAvatar(
                radius: 25.h,
                child: Image.asset("images/drawer/people1.png"),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            const Text('User Name'),
            SizedBox(
              height: 12.h,
            ),
            Container(
              height: 0.6.h,
              width: 200.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 25.w,
              ),
              title: Text("設定"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                size: 25.w,
              ),
              title: Text("選項一"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
            ListTile(
              leading: Icon(
                Icons.alarm,
                size: 25.w,
              ),
              title: Text("選項2"),
              //onTap: () { },
            ),
            Divider(
              height: 1,
              thickness: 2.0,
            ),
          ],
        ),
      ),
    ],
  ));
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
      drawer: drawer(),

      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
            sKey.currentState?.openDrawer();
          }
        },
        child: Center(
          child: MyBackGround(myWiget: _pages[_currentIndex]),
        ),
      ),
    );
  }
}


