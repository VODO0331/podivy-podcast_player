import 'package:podivy/Page/personal/followedPage/followed_page.dart';
import 'package:podivy/Page/personal/media/list/Page/list_page.dart';
import 'package:podivy/Page/login/auth_middleware.dart';
import 'package:podivy/Page/common/podcasterPage/podcaster_page.dart';
import 'package:podivy/Page/common/search/page/search_page.dart';
import 'package:podivy/Page/test.dart';
import 'package:podivy/Page/personal/user_page/user_page.dart';
import 'package:get/get.dart';
import '../Page/personal/playerPage/player_page.dart';

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
      page: () => const TestPage(),
    ),
    GetPage(
      name: "/user",
      page: () => UserPage(),
    ),
    GetPage(
      name: "/podcaster",
      page: () => PodcasterPage(),
    ),
    GetPage(
      name: "/followed",
      page: () => const FollowedPage(),
    ),
  ];
}
