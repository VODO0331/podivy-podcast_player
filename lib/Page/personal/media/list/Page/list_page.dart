import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';

import '../build/build_list.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});
  final IconData icon = Get.arguments['icon'];
  final UserList list = Get.arguments['list'];
  final ListManagement listManagement = Get.find();

  @override
  Widget build(BuildContext context) {
    final RxString title = list.listTitle.obs;
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Theme.of(Get.context!).colorScheme.background
          : Theme.of(Get.context!).colorScheme.secondaryContainer,
      appBar: listAppBar(
        list: list,
        listManagement: listManagement,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 0, 10).r,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 80.r,
                  ),
                  Obx(() => Text(
                        title.value,
                        style: const TextStyle(fontSize: 29),
                      )),
                ],
              ),
            ),
            Expanded(
                child: BuildList(
              list: list,
              listManagement: listManagement,
            )),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget listAppBar({
  required UserList list,
  required ListManagement listManagement,
}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios_rounded),
    ),
  );
}
