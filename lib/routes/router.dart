import 'package:flutter/material.dart';
import 'package:podivy/Page/ListPage.dart';
import 'package:podivy/Page/searchPage.dart';
import 'package:podivy/Page/tabs.dart';

import '../Page/playerPage.dart';

class RouterPage {
  final List myList = [];
  static final routes = [
    GetPage(
      name: "/",
      page: () => const Tabs(),
    ),
    GetPage(
      name: "/player",
      page: () => const PlayerPage(),
    ),
    GetPage(
      name: "/search",
      page: () => const SerchPage(),
    ),
    GetPage(name: "/ListPage", page: () => const ListPage(), parameters: {
      'listTitle': 'YourListTitle',
      'myList': '',
    }),
  ];
}
