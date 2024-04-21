import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/widget/extras.dart';
import 'package:provider/provider.dart';

class EpisodesBuilder extends StatefulWidget {
  final List<Episode>? episodes;
  const EpisodesBuilder({super.key, required this.episodes});

  @override
  State<EpisodesBuilder> createState() => _EpisodesBuilderState();
}

class _EpisodesBuilderState extends State<EpisodesBuilder> {
  late final dynamic myAudioPlayer;
  @override
  void initState() {
    super.initState();
    myAudioPlayer = Provider.of<MyAudioPlayer>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.episodes == null) {
      return Center(
        child: Text('dataNotFind'.tr),
      );
    } else {
      return Consumer<MyAudioPlayer>(builder: (context, value, child) {
        return SliverList.builder(
          key: UniqueKey(),
          itemCount: widget.episodes!.length,
          itemBuilder: (BuildContext context, int index) {
            Episode episode = widget.episodes![index];

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
                    placeholderCacheWidth: 50.r.toInt(),
                    placeholderCacheHeight: 50.r.toInt(),
                    imageCacheHeight: 130.r.toInt(),
                    imageCacheWidth: 130.r.toInt(),
                    fit: BoxFit.cover,
                    placeholderFit: BoxFit.cover,
                    placeholder: "assets/images/generic/search_loading.gif",
                    image: episode.imageUrl,
                    imageErrorBuilder: (context, _, __) {
                      return Image.asset(
                        "assets/images/podcaster/defaultPodcaster.jpg",
                        fit: BoxFit.cover,
                        cacheHeight: 100.r.toInt(),
                        cacheWidth: 100.r.toInt(),
                      );
                    },
                  ),
                ),
                trailing: Extras(
                    episodeData: episode,
                    icon: const Icon(Icons.more_vert_outlined)),
                onTap: () {
                  myAudioPlayer.setIndex(index, widget.episodes!);
                  Get.toNamed('/search/player', arguments: {
                    'episodes': widget.episodes,
                    'index': index,
                  });
                },
              ),
            );
          },
        );
      });
    }
  }
}
