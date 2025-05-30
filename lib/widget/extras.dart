import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart' show Episode;
import 'package:podivy/util/dialogs/list_option.dart';

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
                      title: Text("Add To List".tr),
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
