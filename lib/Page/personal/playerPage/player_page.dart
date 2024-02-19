import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/playerPage/build/build_player_control.dart';
import 'package:search_service/search_service_repository.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final List<Episode> getEpisodeList = Get.arguments['episodes'];
  final Podcaster? podcasterData = Get.arguments['podcaster'];
  final int getIndex = Get.arguments['index'];
  late String? imageUrl;

  @override
  void initState() {
    super.initState();

    final Episode currentEpisodeData = getEpisodeList[getIndex];
    imageUrl = currentEpisodeData.podcast?.imageUrl ?? podcasterData!.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Player'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.w,
              height: 200.h,
              child: ClipRRect(
                borderRadius:  BorderRadius.circular(20),
                child: FadeInImage.assetNetwork(
                  placeholderCacheWidth: 50,
                  placeholderCacheHeight: 50,
                  imageCacheHeight: 200,
                  imageCacheWidth: 200,
                  fit: BoxFit.cover,
                  placeholderFit: BoxFit.cover,
                  placeholder: "assets/images/generic/search_loading.gif",
                  image: imageUrl!,
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
            ),
            SizedBox(height: 20.h),
            PlayerControl(
              getEpisodeList: getEpisodeList,
              getIndex: getIndex,
              podcasterData: podcasterData,
              onParameterChanged: (newImageUrl) {
                if (imageUrl != newImageUrl) {
                  setState(() {
                    imageUrl = newImageUrl;
                  });
                }
              },
            ),
          ],
        ));
  }
}
