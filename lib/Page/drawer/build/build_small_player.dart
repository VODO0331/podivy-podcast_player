import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';

class SmallPlayer extends StatelessWidget {
  final MyAudioPlayer ctr;
  const SmallPlayer({super.key, required this.ctr});

  @override
  Widget build(BuildContext context) {
    final colors = Get.isDarkMode
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondaryContainer;
    return Center(
      child: GestureDetector(
        onTap: () => Get.offAndToNamed('/player'),
        child: Container(
          padding: const EdgeInsets.all(8).r,
          height: 130.r,
          width: 300.r,
          decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground, width: 3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ctr.episodeData.value!.title,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: ctr.player.sequenceStateStream,
                      builder: (context, snapshot) => IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: ctr.player.hasPrevious
                              ? () => ctr.player.seekToPrevious()
                              : null)),
                  StreamBuilder(
                    stream: ctr.player.playerStateStream,
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
                  StreamBuilder(
                    stream: ctr.player.sequenceStateStream,
                    builder: (context, snapshot) => IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: ctr.player.hasNext
                            ? () => ctr.player.seekToNext()
                            : null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
