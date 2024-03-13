import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/personal/playerPage/build/build_player_control.dart';
import 'package:podivy/service/audio_player.dart';
import 'package:search_service/search_service_repository.dart';
// import 'dart:developer' as dev show log;



class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final List<Episode> getEpisodeList = Get.arguments['episodes'];
  final int getIndex = Get.arguments['index'];
  late final MyAudioPlayer _myAudioPlayer;

  @override
  void initState() {
    super.initState();


    _myAudioPlayer =
        MyAudioPlayer(episodeList: getEpisodeList, index: getIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _myAudioPlayer.dispose;
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
                  borderRadius: BorderRadius.circular(20),
                  child: Obx(() {
                    if (_myAudioPlayer.currentImageUrl.value != "") {
                      // dev.log("處發換player圖片");
                      return FadeInImage.assetNetwork(
                        placeholderCacheWidth: 50,
                        placeholderCacheHeight: 50,
                        imageCacheHeight: 250,
                        imageCacheWidth: 250,
                        fit: BoxFit.cover,
                        placeholderFit: BoxFit.cover,
                        placeholder: "assets/images/generic/search_loading.gif",
                        image: _myAudioPlayer.currentImageUrl.value,
                        imageErrorBuilder: (context, _, __) {
                          return Image.asset(
                            "assets/images/podcaster/defaultPodcaster.jpg",
                            fit: BoxFit.cover,
                            cacheHeight: 100,
                            cacheWidth: 100,
                          );
                        },
                      );
                    } else {
                      return Image.asset(
                        "assets/images/podcaster/defaultPodcaster.jpg",
                        fit: BoxFit.cover,
                      );
                    }
                  })),
            ),
            SizedBox(height: 20.h),
            PlayerControl(
              myAudioPlayer: _myAudioPlayer,
            ),
          ],
        ));
  }
}
