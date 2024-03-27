import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/widget/extras.dart';
import 'package:provider/provider.dart';
import 'package:search_service/search_service_repository.dart';

class EpisodesSection extends StatefulWidget {
  final List<Episode>? getEpisodes;
  final Podcaster podcasterDate;

  const EpisodesSection({
    super.key,
    required this.getEpisodes,
    required this.podcasterDate,
  });

  @override
  State<EpisodesSection> createState() => _EpisodesSectionState();
}

class _EpisodesSectionState extends State<EpisodesSection> {
  // final RxBool listSort = true.obs;
  late final dynamic myAudioPlayer;
  @override
  void initState() {
    super.initState();
    myAudioPlayer = Provider.of<MyAudioPlayer>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final RxBool listSort = true.obs;
    if (widget.getEpisodes == null) {
      return Expanded(child: Text("No Content".tr));
    } else {
      return Consumer<MyAudioPlayer>(builder: (context, value2, child) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0).r,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton(
                      position: PopupMenuPosition.under,
                      icon: const Icon(Icons.sort_sharp),
                      onSelected: (value) {
                        listSort.value = value;
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: true,
                            child: Text("newest".tr),
                          ),
                          PopupMenuItem(
                            value: false,
                            child: Text("oldest".tr),
                          ),
                        ];
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 9.0).r,
                      child: Text('Count :${widget.getEpisodes!.length} '.tr),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                Obx(() => BuildEpisodeList(
                      getEpisodes: widget.getEpisodes!,
                      podcasterDate: widget.podcasterDate,
                      listSort: listSort.value,
                      myAudioPlayer: myAudioPlayer,
                    ))
              ],
            ),
          ),
        );
      });
    }
  }
}

class BuildEpisodeList extends StatelessWidget {
  final List<Episode> getEpisodes;
  final Podcaster podcasterDate;
  final bool listSort;
  final dynamic myAudioPlayer;
  const BuildEpisodeList(
      {super.key,
      required this.getEpisodes,
      required this.podcasterDate,
      required this.listSort,
      required this.myAudioPlayer});

  @override
  Widget build(BuildContext context) {
    final episodes = listSort ? getEpisodes : getEpisodes.reversed.toList();
    // myAudioPlayer.setPlayList = episodes;
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: episodes.length,
        itemBuilder: (BuildContext context, int index) {
          final Episode getEpisode = episodes[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).h,
            child: ListTile(
              title: Text(
                getEpisode.title,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Extras(
                  episodeData: getEpisode, icon: const Icon(Icons.more_vert)),
              onTap: () {
                myAudioPlayer.setIndex(index, episodes);
                Get.toNamed(
                  "/podcaster/player",
                );
              },
            ),
          );
        },
      ),
    );
  }
}
