import 'package:firestore_service_repository/error_exception/list_storage_exception.dart';
import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart' show Episode;
import 'package:podivy/util/toast/success_toast.dart';
import 'package:podivy/util/toast/waring.toast.dart';
// import 'dart:developer' as dev show log;

Future listDialog(BuildContext context, Episode episode) async {
  final fsp = Get.find<FirestoreServiceProvider>();
  final Rxn<UserList> userList = Rxn();
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text('Add To List'.tr),
        content: SizedBox(
          height: 200.h,
          width: 300.w,
          child: ListOption(
              onChanged: (value) {
                userList.value = value;
              },
              fsp: fsp),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Create'.tr),
            onPressed: () async {
              await addListDialog(context, episode);
            },
          ),
          TextButton(
            child: Text('Cancel'.tr),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('Add'.tr),
            onPressed: () async {
              if (userList.value != null) {
                if (await fsp.list.addEpisodeToList(userList.value!, episode)) {
                  toastSuccess('Added To List'.tr);
                } else {
                  toastWaning('Already added to the list'.tr);
                }
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
  final FirestoreServiceProvider fsp;
  ListOption({super.key, required this.onChanged, required this.fsp});

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
      stream: fsp.list.readAllList(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allList = snapshot.data;

              return Obx(() => Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Tag List'.tr),
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
  final fsp = Get.find<FirestoreServiceProvider>();
  final TextEditingController textEditingController =
      Get.put(TextEditingController(),tag: 'listNameAdd:${episode.id}');
   await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text('Create'.tr),
        content: SizedBox(
          height: 100.h,
          width: 300.w,
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: "list Name".tr,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'.tr),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('Add'.tr),
            onPressed: () async {
              try {
                if (await fsp.list
                    .addList(textEditingController.text, episode)) {
                  toastSuccess('List added'.tr);
                }
              } catch (e) {
                
                switch (e) {
                  case ListNameAlreadyUsed():
                    toastWaning('The name is already in use'.tr);
                  default:
                    toastWaning('Error'.tr);
                }
              }
              textEditingController.text = "";
              Get.back();
              Get.back();
            },
          ),
        ],
      );
    },
  );
  if (Get.isRegistered<TextEditingController>(
     tag: 'listNameAdd:${episode.id}')) {
    Get.delete<TextEditingController>(tag: 'listNameAdd:${episode.id}');
  }
}
