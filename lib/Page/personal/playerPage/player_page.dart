import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Page/personal/playerPage/build/build_player_control.dart';
import 'package:search_service/search_service_repository.dart';

import 'build/build_episode_info.dart';
// import 'dart:developer' as dev show log;

class PlayerPage extends StatelessWidget {
  PlayerPage({super.key});

  final List<Episode> getEpisodeList = Get.arguments['episodes'];

  final int getIndex = Get.arguments['index'];

  final MyAudioPlayer _myAudioPlayer = MyAudioPlayer(
      episodeList: Get.arguments['episodes'], index: Get.arguments['index']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Player'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _myAudioPlayer.player.sequenceStateStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox.shrink();
                  }
                  return BuildEpisodeInfo(
                    currentEpisodeData: state!.currentSource!.tag,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            PlayerControl(
              myAudioPlayer: _myAudioPlayer,
            ),
          ],
        ));
  }
}
