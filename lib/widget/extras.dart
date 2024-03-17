import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/list_option.dart';
import 'package:search_service/search_service_repository.dart';

class Extras extends StatelessWidget {
  final Episode episodeData;
  final Icon icon;
  const Extras({super.key, required this.episodeData, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(8).r,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30))),
                height: 300.r,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                        alignment: Alignment.topCenter,
                        child: Icon(Icons.keyboard_arrow_down_rounded)),
                    ListTile(
                      leading: const Icon(Icons.post_add),
                      title: const Text("添加到清單"),
                      onTap: () async {
                        Get.back();
                        await listDialog(context, episodeData);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    )
                  ],
                ),
              );
            },
          );
        },
        icon: icon);
  }
}
