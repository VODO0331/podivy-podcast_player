import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/widget/extras.dart';
import 'package:search_service/search_service_repository.dart';

class EpisodesSection extends StatelessWidget {
  final List<Episode>? getEpisodes;
  final Podcaster podcasterDate;

  const EpisodesSection({
    super.key,
    required this.getEpisodes,
    required this.podcasterDate,
  });
  // final RxBool listSort = true.obs;
  @override
  Widget build(BuildContext context) {
    final RxBool listSort = true.obs;
    if (getEpisodes == null) {
      return Expanded(child: Text("No Content".tr));
    } else {
      return Expanded(
        child: SizedBox(
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
                      child: Text('Count :${getEpisodes!.length} '.tr),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                Obx(
                  () => _buildEpisodesList(
                    getEpisodes!,
                    podcasterDate,
                    listSort,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

Widget _buildEpisodesList(
  List<Episode> getEpisodes,
  Podcaster podcasterDate,
  RxBool listSort,
) {
  getEpisodes = listSort.value ? getEpisodes : getEpisodes.reversed.toList();
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: getEpisodes.length,
      itemBuilder: (BuildContext context, int index) {
        final Episode getEpisode = getEpisodes[index];

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
              Get.toNamed("/player", arguments: {
                'podcaster': podcasterDate,
                'episodes': getEpisodes,
                'index': index,
              });
            },
          ),
        );
      },
    ),
  );
}
