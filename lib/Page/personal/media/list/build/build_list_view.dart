import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart' show Episode;
import 'package:podivy/Page/personal/media/build/enum_sort.dart';

typedef EpisodeCallBack = void Function(Episode episode);
typedef PlayerCallBack = void Function(List<Episode> episodes, int index);

class BuildListView extends StatelessWidget {
  final Iterable<Episode> episodes;
  final EpisodeCallBack onDelete;
  final PlayerCallBack onTap;
  final Sort sort;
  const BuildListView(
      {super.key,
      required this.episodes,
      required this.onDelete,
      required this.onTap,
      required this.sort});

  @override
  Widget build(BuildContext context) {
    final resultOfSort = sortOfEpisode(sort, episodes);
    return ListView.builder(
      padding: EdgeInsets.zero,
      prototypeItem: prototypeItem(),
      itemCount: episodes.length,
      itemBuilder: (BuildContext context, int index) {
        final episode = resultOfSort.elementAt(index);
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10).h,
                child: Dismissible(
                  key: Key(episode.title),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 40).r,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete_outline_outlined),
                  ),
                  onDismissed: (direction) {
                    onDelete(episode);
                  },
                  child: ListTile(
                    title: Text(
                      episode.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: SizedBox(
                        height: 50.r,
                        width: 50.r,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder:
                              'assets/images/podcaster/defaultPodcaster.jpg',
                          image: episode.imageUrl,
                          imageErrorBuilder: (context, _, __) {
                            return Image.asset(
                              'assets/images/podcaster/defaultPodcaster.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        )),
                    onTap: () {
                      onTap(resultOfSort.toList(), index);
                    },
                  ),
                ))
          ],
        );
      },
    );
  }
}

Iterable<Episode> sortOfEpisode(Sort sort, Iterable<Episode> episodes) {
  switch (sort) {
    case Sort.addTimeOldToNew:
      return episodes.toList().reversed;

    case Sort.addTimeNewToOld:
      return episodes;

    case Sort.releaseOldToNew:
      List<Episode> episodeList = episodes.toList();
      episodeList.sort((a, b) {
        return a.airDate.compareTo(b.airDate);
      });
      return episodeList;

    case Sort.releaseNewToOld:
      List<Episode> episodeList = episodes.toList();
      episodeList.sort((a, b) {
        return a.airDate.compareTo(b.airDate);
      });
      return episodeList.reversed;
    default:
      return episodes;
  }
}

Widget prototypeItem() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10).h,
        child: ListTile(
            title: const Text(
              'testTitle',
              overflow: TextOverflow.ellipsis,
            ),
            leading: SizedBox(
                height: 50.r,
                width: 50.r,
                ),
            trailing: PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      //  onDelete(list);
                    },
                    child: Text("delete".tr),
                  )
                ];
              },
            )),
      )
    ],
  );
}
