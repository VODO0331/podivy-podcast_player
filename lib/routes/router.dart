import 'package:podivy/Page/common/settingPage/setting_page.dart';
import 'package:podivy/Page/personal/followedPage/following_page.dart';
import 'package:podivy/Page/personal/media/list/Page/list_page.dart';
import 'package:podivy/Page/login/auth_middleware.dart';
import 'package:podivy/Page/common/podcasterPage/podcaster_page.dart';
import 'package:podivy/Page/common/search/search_page.dart';
import 'package:podivy/Page/personal/user_page/user_page.dart';
import 'package:get/get.dart';
import '../Page/personal/playerPage/player_page.dart';

class RouterPage {
  static final routes = [
    GetPage(
        name: AppRoutes.authMiddleWare,
        page: () => const AuthMiddleWare(),
        children: [
         
        
          //player 頁面
          GetPage(name: AppRoutes.player,page: () => const PlayerPage(),),
          //搜尋頁面
          GetPage(name: AppRoutes.search, page: () => SearchPage(), children: [
            GetPage(
              name: AppRoutes.player,
              page: () => const PlayerPage(),
            ),
            GetPage(
              name: AppRoutes.podcaster,
              page: () => PodcasterPage(),
            ),
          ]),
          //清單頁面
          GetPage(name: AppRoutes.listPage, page: () => ListPage(), children: [
            GetPage(name: AppRoutes.player, page: () => const PlayerPage()),
          ]),
          //設定頁面
          GetPage(
            name: AppRoutes.setting,
            page: () =>const SettingPage(),
          ),
          //用戶頁面
          GetPage(
            name: AppRoutes.user,
            page: () => UserPage(),
          ),
          //podcaster頁面
          GetPage(
              name: AppRoutes.podcaster,
              page: () => PodcasterPage(),
              children: [
                GetPage(
                  name: AppRoutes.player,
                  page: () => const PlayerPage(),
                ),
              ]),
          //追隨頁面
          GetPage(
              name: AppRoutes.follow,
              page: () =>  FollowPage(),
              children: [
                GetPage(
                  name: AppRoutes.podcaster,
                  page: () => PodcasterPage(),
                  children: [
                    GetPage(
                      name: AppRoutes.player,
                      page: () => const PlayerPage(),
                    ),
                  ],
                ),
              ]),
        ]),
  ];
}

abstract class AppRoutes {
  static const authMiddleWare = '/';
  static const search = '/search';
  static const tabs = '/tabs';
  static const listPage = '/listPage';
  static const setting = '/setting';
  static const user = '/user';
  static const podcaster = '/podcaster';
  static const follow = '/follow';
  static const player = '/player';
}


