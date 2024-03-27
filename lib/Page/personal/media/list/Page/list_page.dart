import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

import '../build/build_list.dart';

class ListPage extends StatelessWidget {
  ListPage({super.key});
  final IconData icon = Get.arguments['icon'];
  final UserList list = Get.arguments['list'];
  final ListManagement listManagement = Get.find();

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    list.listTitle,
                    style: const TextStyle(fontSize: 29),
                  )
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
    actions: [
      PopupMenuButton(
        color: Theme.of(Get.context!).colorScheme.primary,
        icon: const Icon(
          Icons.more_vert_sharp,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: true,
              child: Text('Edit'.tr),
              onTap: () async {
                dev.log("here");
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController textEditingController =
                          Get.put(TextEditingController());
                      return AlertDialog(
                        title: Text('New list name'.tr),
                        content: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                              hintText: 'Please enter the new name'.tr),
                          onChanged: (value) {
                            textEditingController.text = value; 
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 取消
                            },
                            child: Text('Cancel'.tr),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              listManagement.updateList(
                                  list, textEditingController.text);
                              Get.back();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    });
              },
            )
          ];
        },
      ),
    ],
  );
}
