import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/widget/extras.dart';
import 'package:search_service/search_service_repository.dart';

class EpisodesBuilder extends StatelessWidget {
  final List<Episode>? episodes;
  const EpisodesBuilder({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    if (episodes == null) {
      return Center(
        child: Text('dataNotFind'.tr),
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
              trailing: Extras(
                  episodeData: episode,
                  icon: const Icon(Icons.more_vert_outlined)),
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
