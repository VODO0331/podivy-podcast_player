import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart' show Episode;

Future listDialog(BuildContext context, Episode episode) async {
  final ListManagement listManagement = Get.find();
  late UserList list;
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
              // dev.log(value);
              list = UserList(listTitle: value);
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('添加清單'),
            onPressed: () async{
              Get.back();
              await addListDialog(context, episode);
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
              await listManagement.addEpisodeToList(list, episode);
              Get.back();
            },
          ),
        ],
      );
    },
  );
}

typedef ListOptionCallback = void Function(String list);

class ListOption extends StatelessWidget {
  final ListOptionCallback onChanged;
  ListOption({super.key, required this.onChanged});
  final ListManagement listManagement = Get.find();
  final RxString groupValue = "TagList".obs;

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
              onChanged(value);
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
                            onChanged(value);
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
              // ignore: unused_local_variable
              UserList userList =
                  UserList(listTitle: textEditingController.text);
              await listManagement.addEpisodeToList(userList, episode);
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
