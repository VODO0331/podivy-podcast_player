import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/media/list/build/build_list_view.dart';

import '../../build/enum_sort.dart';

class BuildList extends StatelessWidget {
  final UserList list;
  final ListManagement listManagement;
  BuildList({
    super.key,
    required this.listManagement,
    required this.list,
  });

  final Rx<Sort> sort = Sort.addTimeNewToOld.obs;
  Widget listHeader(int count) {
    return Row(
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
              return [
                PopupMenuItem(
                  value: Sort.addTimeNewToOld,
                  child: Text('Add time (new > old)'.tr),
                ),
                PopupMenuItem(
                  value: Sort.addTimeOldToNew,
                  child: Text('Add time (old > new)'.tr),
                ),
                PopupMenuItem(
                  value: Sort.releaseOldToNew,
                  child: Text('Release time (old > new)'.tr),
                ),
                PopupMenuItem(
                  value: Sort.releaseNewToOld,
                  child: Text('Release time (new > old)'.tr),
                ),
              ];
            },
          ),
        ),
        TextButton(
          onPressed: null,
          child: Text(
            'Count :$count'.tr,
            style: TextStyle(
                textBaseline: TextBaseline.alphabetic, fontSize: 15.r),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listManagement.readListContent(list),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final episodes = snapshot.data;
              return Column(
                children: [
                  listHeader(episodes!.length),
                  const Divider(
                    thickness: 1,
                  ),
                  Expanded(
                      child: Obx(
                    () => BuildListView(
                      episodes: episodes,
                      onDelete: (
                        episode,
                      ) async {
                        await listManagement.deleteEpisodeFromList(
                            list, episode);
                      },
                      onTap: (episodes, index) {
                        //player
                        Get.toNamed('/player',
                            arguments: {'episodes': episodes, 'index': index});
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
    );
  }
}
