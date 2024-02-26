import 'package:flutter/material.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:get/get.dart';
import 'package:podivy/Page/personal/media/list/build/build_episode_list.dart';
import 'package:podivy/Page/personal/media/build/enum_sort.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final  IconData icon = Get.arguments['icon'];
    final UserList list = Get.arguments['list'];
    final ListManagement listManagement = Get.find();
    final Rx<Sort> sort = Sort.addTimeNewToOld.obs;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      appBar: AppBar(),
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
              child: StreamBuilder(
                stream: listManagement.readListContent(list),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final episodes = snapshot.data;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Obx(
                                  () => PopupMenuButton(
                                    icon: const Icon(Icons.sort_sharp),
                                    position: PopupMenuPosition.under,
                                    initialValue: sort.value,
                                    onSelected: (value) => sort.value = value,
                                    itemBuilder: (context) {
                                      return const [
                                        PopupMenuItem(
                                          value: Sort.addTimeNewToOld,
                                          child: Text('新增時間(新>舊)'),
                                        ),
                                        PopupMenuItem(
                                          value: Sort.addTimeOldToNew,
                                          child: Text('新增時間(舊>新)'),
                                        ),
                                        
                                        PopupMenuItem(
                                          value: Sort.releaseOldToNew,
                                          child: Text('發布時間(舊>新)'),
                                        ),
                                        PopupMenuItem(
                                          value: Sort.releaseNewToOld,
                                          child: Text('發布時間(新>舊)'),
                                        ),
                                      ];
                                    },
                                  ),
                                ),
                                TextButton(
                                  onPressed: null,
                                  child: Text(
                                    '${episodes!.length} 部',
                                    style: TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontSize: 15.r),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            Expanded(
                                child: Obx(
                              () => ListBuilder(
                                episodes: episodes,
                                onDelete: (episode, ) async {
                                  await listManagement.deleteEpisodeFromList(
                                      list, episode);
                                },
                                onTap: (episodes, index) {
                                  //player
                                  Get.toNamed('/player', arguments: {
                                    'episodes': episodes,
                                    'index': index
                                  });
                                },
                                sort: sort.value,
                              ),
                            )),
                          ],
                        );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
