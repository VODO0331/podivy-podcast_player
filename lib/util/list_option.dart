import 'package:firestore_service_repository/firestore_service_repository.dart' ;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart' show Episode;
import 'dart:developer' as dev show log;

Future listDialog(BuildContext context, Episode episode) async {
  final ListManagement listManagement = Get.find();
  final Rxn<UserList> userList = Rxn();
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('添加清單'),
        content: SizedBox(
          height: 200.h,
          width: 300.w,
          child: ListOption(
            onChanged: (value) {
              userList.value = value;
              dev.log(userList.value!.docId);
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('添加清單'),
            onPressed: () async {
              await addListDialog(context, episode);
              Get.back();
            },
          ),
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('添加'),
            onPressed: () async {
              if (userList.value != null) {
                await listManagement.addEpisodeToList(userList.value!, episode);
              }

              Get.back();
            },
          ),
        ],
      );
    },
  );
}

typedef ListOptionCallback = void Function(UserList list);

class ListOption extends StatelessWidget {
  final ListOptionCallback onChanged;
  ListOption({super.key, required this.onChanged});
  final ListManagement listManagement = Get.find();
  final RxString groupValue = "".obs;

  Widget optionBuilder(Iterable<UserList>? allList) {
    if (allList == null) {
      return const SizedBox.shrink(); // 如果 allList 為空，返回一個空的小部件
    }
    return ListView.builder(
      shrinkWrap: true,
      prototypeItem: listOptionPrototype(),
      itemCount: allList.length,
      itemBuilder: (context, index) {
        final list = allList.elementAt(index);

        return ListTile(
          title: Text(list.listTitle),
          leading: Radio(
            value: list.listTitle,
            groupValue: groupValue.value,
            onChanged: (value) {
              groupValue.value = value!;
              onChanged(list);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listManagement.readAllList(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allList = snapshot.data;

              return Obx(() => Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('標籤清單'),
                        leading: Radio(
                          value: "TagList",
                          groupValue: groupValue.value,
                          onChanged: (value) {
                            groupValue.value = value!;
                            onChanged(UserList(
                              docId: "TagList",
                              listTitle: "TagList",
                            ));
                          },
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: optionBuilder(allList),
                      )
                    ],
                  ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

Widget listOptionPrototype() {
  return ListTile(
    title: const Text("test"),
    leading: Radio(
      value: 0,
      groupValue: 0,
      onChanged: (value) {},
    ),
  );
}

Future addListDialog(BuildContext context, Episode episode) async {
  final ListManagement listManagement = Get.find();
  final TextEditingController textEditingController =
      Get.put(TextEditingController());
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('添加清單'),
        content: SizedBox(
          height: 100.h,
          width: 300.w,
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  labelText: "清單名稱",
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('添加'),
            onPressed: () async {
              await listManagement.addList(textEditingController.text, episode);
              textEditingController.text = "";
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
