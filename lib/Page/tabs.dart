import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:information_management_service/personal_information_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/common/homePage/home_page.dart';
import 'package:podivy/widget/background.dart';
import 'package:podivy/Page/personal/media/media_page.dart';
import 'package:podivy/widget/drawer.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  final int totalPage = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late final InformationManagement _userController;
  int _currentPage = 0;
  final List<String> _names = ['Home', 'Media'];
  final List<IconData> _icons = [Icons.home_rounded, Icons.all_inbox];
  final InformationController controller = Get.put(InformationController());
  @override
  void initState() {
    super.initState();
    // _userController = InformationManagement();
    // _userController.haveInfo(); // 只有在首次登錄後執行一次
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _userController;
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InformationController>(
      builder: (controller) {
        // if (controller.userData != null) {
        return Scaffold(
          key: _scaffoldKey,
          body: BottomBarPageTransition(
            builder: (_, index) => _getBody(index),
            currentIndex: _currentPage,
            totalLength: totalPage,
            transitionType: TransitionType.circular,
            transitionDuration: const Duration(milliseconds: 500),
            transitionCurve: Curves.easeInOut,
          ),
          bottomNavigationBar: _getBottomBar(),
          drawer: const MyDrawer(),
        );
        // } else {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        // );
        // }
      },
    );
  }

  Widget _getBottomBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF141513),
      iconSize: ScreenUtil().setHeight(35),
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
          icon: Icon(_icons[index]),
          label: _names[index],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
          _scaffoldKey.currentState?.openDrawer();
        }
      },
      child: MyBackGround(
          child: index == 0 ? const HomePage() : const MediaPage()),
    );
  }
}
