import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';

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
      return const Expanded(child: Text("無內容"));
    } else {
      return Expanded(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color.fromARGB(124, 44, 39, 29),
                Color.fromARGB(221, 44, 39, 29),
              ],
              stops: [0.4,0.7, 1],
            ),
          ),
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
                      color: Colors.black54,
                      onSelected: (value) {
                        listSort.value = value;
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: true,
                            child: Text("最新"),
                          ),
                          const PopupMenuItem(
                            value: false,
                            child: Text("最舊"),
                          ),
                        ];
                      },
                    ),
                    Text('${getEpisodes!.length} 部'),
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
            trailing: const Icon(Icons.more_vert),
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
