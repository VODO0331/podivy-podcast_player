import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'package:podivy/Page/common/homePage/home_page.dart';
import 'package:podivy/widget/background.dart';
import 'package:podivy/Page/personal/media/media_page.dart';
import 'package:podivy/Page/drawer/drawer.dart';

class Tabs extends StatefulWidget {
  // final InformationController informationController;
  const Tabs({
    super.key,
  });

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final int totalPage = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late final InformationManagement _userController;
  int _currentPage = 0;
  final List<String> _names = ['Home', 'Media'];

  final List<IconData> _icons = [Icons.home_rounded, Icons.all_inbox];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _getBody(_currentPage),
      bottomNavigationBar: _getBottomBar(),
      drawer: const MyDrawer(),
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      backgroundColor: Get.isDarkMode
          ? null
          : Theme.of(context).colorScheme.secondaryContainer,
      // iconSize:600.r,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentPage,

      onTap: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        totalPage,
        (index) => BottomNavigationBarItem(
          icon: Icon(
            _icons[index],
            size: 35.h,
          ),
          label: _names[index],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    initializationMyFirestoreService();
    final informationController = Get.find<InformationController>();
    final listManagement = Get.find<ListManagement>();
    
    final followedManagement = Get.find<FollowedManagement>();
    final interestsManagement = Get.find<InterestsManagement>();
    final List<Widget> body = [
      HomePage(
        infoController: informationController,
        followedManagement: followedManagement,
        interestsManagement: interestsManagement,
      ),
      MediaPage(
        listManagement: listManagement,
      )
    ];
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
          _scaffoldKey.currentState?.openDrawer();
        }
      },
      child: MyBackGround(
          child:  IndexedStack(index: index,children: body,)
      ),
    );
  }
}
