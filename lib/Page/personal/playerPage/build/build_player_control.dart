

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:list_management_service/personal_list_management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/service/audio_player.dart';
// import 'package:podivy/util/dialogs/cannot_play.dart';
import 'package:podivy/util/dialogs/description_dialog.dart';
import 'package:podivy/util/list_option.dart';

import 'package:search_service/search_service_repository.dart';

typedef ImgCallback = String? Function(String? newImageUrl);

class PlayerControl extends StatelessWidget {
  final MyAudioPlayer myAudioPlayer;
  PlayerControl({super.key, required this.myAudioPlayer});
  final ListManagement listManagement = Get.find();

  @override
  Widget build(BuildContext context) {
    final Rx<Duration> currentPosition = myAudioPlayer.position;
    return Column(
      children: [
        Obx(() => BuildSongInfo(
            currentEpisodeData: myAudioPlayer.currentEpisodeData.value)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 20.h),
                _buildProgressBar(currentPosition),
                _buildTimeLabels(currentPosition),
                SizedBox(height: 10.h),
                _buildControlButtons(),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(8).r,
                        height: 300.r,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "選擇項目",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                            ListTile(
                              leading:const  Icon(Icons.post_add),
                              title: const Text("添加到清單"),
                              onTap: () => listDialog(context,  myAudioPlayer.currentEpisodeData.value),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            )
                          ],
                        ),
                      );
                    },
                  );
                    },
                    icon: const Icon(Icons.menu_rounded))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProgressBar(Rx<Duration> currentPosition) {
    return Obx(() => Slider(
          value: currentPosition.value.inSeconds.toDouble(),
          min: 0,
          max: myAudioPlayer.duration.value.inSeconds.toDouble(),
          onChanged: (value) async {
            currentPosition.value = Duration(seconds: value.toInt());
            await myAudioPlayer.seek(myAudioPlayer.position.value);
          },
        ));
  }

  Widget _buildTimeLabels(Rx<Duration> currentPosition) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24).w,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(currentPosition.value)),
              Text(formatTime(myAudioPlayer.duration.value)),
            ],
          ),
        ));
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () => myAudioPlayer.playPreviousEpisode()),
        const SizedBox(width: 20),
        IconButton(
          iconSize: 30.r,
          icon: const Icon(Icons.replay_10),
          onPressed: () => myAudioPlayer.durationChanges(false),
        ),
        const SizedBox(width: 20),
        StreamBuilder(
          stream: myAudioPlayer.playingStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final bool isPlaying = snapshot.data!;
                return IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                  onPressed: myAudioPlayer.togglePlayPause,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          iconSize: 30.r,
          icon: const Icon(Icons.forward_10),
          onPressed: () => myAudioPlayer.durationChanges(true),
        ),
        const SizedBox(width: 20),
        IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () => myAudioPlayer.playNextEpisode()),
      ],
    );
  }
}

class BuildSongInfo extends StatelessWidget {
  final Episode currentEpisodeData;
  const BuildSongInfo({super.key, required this.currentEpisodeData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDescriptionDialog(context, currentEpisodeData.description);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8).r,
        child: Container(
          padding: const EdgeInsets.all(10).r,
          decoration: BoxDecoration(
              color: const Color(0xFF8A7F6E),
              borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              Text(
                currentEpisodeData.title,
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                currentEpisodeData.podcast.title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
