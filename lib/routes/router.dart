
import 'package:podivy/Page/listPage.dart';
import 'package:podivy/Page/login/authMidleware.dart';
import 'package:podivy/Page/podcasterPage.dart';
import 'package:podivy/Page/searchPage.dart';
import 'package:podivy/Page/test.dart';
import 'package:podivy/Page/userPage.dart';
import 'package:get/get.dart';
import '../Page/playerPage.dart';

class RouterPage {
  final List myList = [];
  static final routes = [
    GetPage(
      name: "/",
      page: () => const AuthMiddleWare(),
    ),
    GetPage(
      name: "/player",
      page: () => const PlayerPage(),
    ),
    GetPage(
      name: "/search",
      page: () => const SearchPage(),
    ),
    GetPage(
      name: "/ListPage",
      page: () => const ListPage(),
      parameters: const {'listTitle': ''},
    ),
    GetPage(
      name: "/test",
      page: () => TestPage(),
    ),
    GetPage(
      name: "/user",
      page: () => const UserPage(),
    ),
    GetPage(
      name: "/podcaster",
      page: () => PodcasterPage(),
    ),
  ];
}
