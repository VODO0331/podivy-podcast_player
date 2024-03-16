import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/list_option.dart';
import 'package:search_service/search_service_repository.dart';

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
      return SliverList.builder(
        key: UniqueKey(),
        // prototypeItem: _prototypeItemForEpisodeBuilder(),
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
              trailing: IconButton(
                icon: const Icon(Icons.more_vert_sharp),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(8).r,
                        height: 300.r,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "選擇項目",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                            ListTile(
                              leading:const  Icon(Icons.post_add),
                              title: const Text("添加到清單"),
                              onTap: () => listDialog(context, episode),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            )
                          ],
                        ),
                      );
                    },
                  );
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
