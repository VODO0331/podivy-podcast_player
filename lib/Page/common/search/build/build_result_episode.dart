import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:search_service/search_service_repository.dart';
import 'dart:developer'as dev show log ;
class EpisodesBuilder extends StatelessWidget {
  final List<Episode>? episodes;
  const EpisodesBuilder({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    if (episodes == null) {
      return const Center(
        child: Text('找尋不到資料'),
      );
    } else {
      return ListView.builder(
        key: UniqueKey(),
        prototypeItem: _prototypeItemForEpisodeBuilder(),
        itemCount: episodes!.length,
        itemBuilder: (BuildContext context, int index) {
          Episode episode = episodes![index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8).h,
            child: ListTile(
              title: Text(episode.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp)),
              leading: SizedBox(
                height: 60.h,
                width: 60.w,
                child: FadeInImage.assetNetwork(
                  placeholderCacheWidth: 50,
                  placeholderCacheHeight: 50,
                  imageCacheHeight: 130,
                  imageCacheWidth: 130,
                  fit: BoxFit.cover,
                  placeholderFit: BoxFit.cover,
                  placeholder: "assets/images/generic/search_loading.gif",
                  image: episode.imageUrl,
                  imageErrorBuilder: (context, _, __) {
                    return Image.asset(
                      "assets/images/podcaster/defaultPodcaster.jpg",
                      fit: BoxFit.cover,
                      cacheHeight: 100,
                      cacheWidth: 100,
                    );
                  },
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text("添加到清單"),
                      onTap: () async {
                        await _listDialog(context, episode);
                      },
                    ),
                  ];
                },
              ),
              onTap: () {
                Get.toNamed('/player', arguments: {
                  'episodes': episodes,
                  'index': index,
                });
              },
            ),
          );
        },
      );
    }
  }
}

Widget _prototypeItemForEpisodeBuilder() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8).h,
    child: ListTile(
      title: Text(
        "episode.title",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.sp),
      ),
      leading: SizedBox(
        height: 60.h,
        width: 60.w,
        child: FadeInImage.assetNetwork(
          placeholderCacheWidth: 50,
          placeholderCacheHeight: 50,
          imageCacheHeight: 100,
          imageCacheWidth: 100,
          fit: BoxFit.cover,
          placeholderFit: BoxFit.cover,
          placeholder: "assets/images/generic/search_loading.gif",
          image: "episode.imageUrl",
          imageErrorBuilder: (context, _, __) {
            return Image.asset(
              "assets/images/podcaster/defaultPodcaster.jpg",
              fit: BoxFit.cover,
              cacheHeight: 100,
              cacheWidth: 100,
            );
          },
        ),
      ),
      trailing: const Icon(Icons.more_vert),
      onTap: null,
    ),
  );
}

Future _listDialog(BuildContext context, Episode episode) async {
  final ListManagement listManagement = Get.find();
  late UserList list;
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('添加清單'),
        content: SizedBox(
          height: 300.h,
          width: 300.w,
          child: ListOption(
            onChanged: (value) {
              dev.log(value);
              list = UserList(listTitle: value);
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('添加'),
            onPressed: () async{
              await listManagement.addEpisodeToList(list, episode);
              Get.back();
            },
          ),
          TextButton(
            child: const Text('取消'),
            onPressed: () {
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
                  Expanded(child: optionBuilder(allList),)
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

Widget listOptionPrototype(){
  return ListTile(
          title:const Text("test"),
          leading: Radio(
            value: 0,
            groupValue: 0,
            onChanged: (value) {
            },
          ),
        );
}