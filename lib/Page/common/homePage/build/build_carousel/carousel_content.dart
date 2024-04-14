import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Controller/widget_animation_controller.dart';
import 'package:provider/provider.dart';
import 'package:search_service/search_service_repository.dart';

class NullCarouselContent extends StatelessWidget {
  const NullCarouselContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Container(
        padding: const EdgeInsets.all(8).r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? const Color(0xFF181B17)
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 10),
                color: Colors.grey,
                blurRadius: 8,
                spreadRadius: 1,
              )
            ]),
        child: AnimatedTextKit(animatedTexts: [
          WavyAnimatedText('Go follow your favorite podcasts'.tr)
        ]),
      ),
    );
  }
}

class CarouselContent extends StatelessWidget {
  final Followed followed;
  CarouselContent({super.key, required this.followed});
  final _loopController = Get.put(LoopController());
  final RxBool isFollowed = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8).r,
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? const Color(0xFF181B17)
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey,
              blurRadius: 8,
              spreadRadius: 1,
            )
          ]),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.r,
                    width: 80.r,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _loopController.animationController!,
                          builder: (context, child) {
                            // dev.log(
                            //     _loopController.boardAnimation!.value.toString());
                            return Obx(() => GestureDetector(
                                  onTap: () => Get.toNamed(
                                      '/followed/podcaster',
                                      arguments: followed.podcastId),
                                  child: Container(
                                    height: 70.r *
                                        _loopController.boardAnimation!.value.r,
                                    width: 70.r *
                                        _loopController.boardAnimation!.value.r,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/generic/search_loading.gif",
                                      image: followed.podcastImg,
                                      imageCacheHeight: 219.r.toInt(),
                                      imageCacheWidth: 219.r.toInt(),
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.r,
                  ),
                  Text(
                    followed.podcastName,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12.sp),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Divider(),
                ],
              )),
          Expanded(
              flex: 1,
              child: VerticalDivider(color: Theme.of(context).primaryColor)),
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(5)),
              child: CarouselListView(
                podcastId: followed.podcastId,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CarouselListView extends StatefulWidget {
  final String podcastId;
  const CarouselListView({super.key, required this.podcastId});

  @override
  State<CarouselListView> createState() => _CarouselListViewState();
}

class _CarouselListViewState extends State<CarouselListView> {
  late final dynamic myAudioPlayer;
  @override
  void initState() {
    super.initState();
    myAudioPlayer = Provider.of<MyAudioPlayer>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSinglePodcasterData(
          id: widget.podcastId, numberOfEpisodesResults: 3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('snapshot Error:${snapshot.error}');
          }
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.episodesList!.length,
            itemBuilder: (context, index) {
              final Episode episode = data.episodesList![index];

              return ListTile(
                title: Text(
                  episode.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp),
                ),
                textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                onTap: () async {
                  myAudioPlayer.setIndex(index, data.episodesList!);
                  await Get.toNamed('/followed/podcaster/player');
                },
              );
            },
          );
        } else {
          return const Center(child: LinearProgressIndicator());
        }
      },
    );
  }
}
