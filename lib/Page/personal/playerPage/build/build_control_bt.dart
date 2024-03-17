

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class BuildControlBt extends StatelessWidget {
  final AudioPlayer player;
  const BuildControlBt({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () =>
                  player.hasPrevious ? player.seekToPrevious() : null),
        ),
        const SizedBox(width: 20),
        IconButton(
          iconSize: 30.r,
          icon: const Icon(Icons.replay_10),
          onPressed: () =>
              player.seek(player.position - const Duration(seconds: 10)),
        ),
        const SizedBox(width: 20),
        StreamBuilder(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

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
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 50.0.r,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 50.0.r,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          iconSize: 30.r,
          icon: const Icon(Icons.forward_10),
          onPressed: () =>
              player.seek(player.position + const Duration(seconds: 10)),
        ),
        const SizedBox(width: 20),
        StreamBuilder(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => player.hasNext ? player.seekToNext() : null),
        ),
      ],
    );
  }
}