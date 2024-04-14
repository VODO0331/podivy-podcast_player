// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/util/dialogs/cannot_play.dart';
import 'package:provider/provider.dart';
class BuildControlBt extends StatelessWidget {
  // final AudioPlayer player;
  const BuildControlBt({
    super.key,
    // required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudioPlayer>(builder: (context, ctr, child) {


      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: ctr.player.sequenceStateStream,
              builder: (context, snapshot) => IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: ctr.player.hasPrevious
                      ? () => ctr.player.seekToPrevious()
                      : null)),
          const SizedBox(width: 20),
          IconButton(
            iconSize: 30.r,
            icon: const Icon(Icons.replay_10),
            onPressed: () => ctr.player
                .seek(ctr.player.position - const Duration(seconds: 10)),
          ),
          const SizedBox(width: 20),
          StreamBuilder(
            stream: ctr.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (snapshot.hasError) {
                showPlayErrorDialog(
                    context, 'Unable to play or try again later'.tr);
              }
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0).r,
                  width: 50.0.r,
                  height: 50.0.r,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 50.0.r,
                  onPressed: ctr.player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 50.0.r,
                  onPressed: ctr.player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 50.0.r,
                  onPressed: () => ctr.player.seek(Duration.zero,
                      index: ctr.player.effectiveIndices!.first),
                );
              }
            },
          ),
          const SizedBox(width: 20),
          IconButton(
            iconSize: 30.r,
            icon: const Icon(Icons.forward_10),
            onPressed: () => ctr.player
                .seek(ctr.player.position + const Duration(seconds: 10)),
          ),
          const SizedBox(width: 20),
          StreamBuilder(
            stream: ctr.player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed:
                    ctr.player.hasNext ? () => ctr.player.seekToNext() : null),
          ),
        ],
      );
    });
  }
}
