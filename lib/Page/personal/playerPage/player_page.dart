import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Page/personal/playerPage/build/build_player_control.dart';
import 'package:search_service/search_service_repository.dart';

import 'build/build_episode_info.dart';
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
    _myAudioPlayer.dispose();
  }

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
