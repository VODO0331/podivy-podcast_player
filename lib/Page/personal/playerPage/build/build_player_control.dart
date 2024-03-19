import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
// import 'package:podivy/util/dialogs/cannot_play.dart';
import 'package:podivy/widget/extras.dart';

import 'build_control_bt.dart';

typedef ImgCallback = String? Function(String? newImageUrl);

class PlayerControl extends StatelessWidget {
  final MyAudioPlayer myAudioPlayer;
  PlayerControl({super.key, required this.myAudioPlayer});
  final ListManagement listManagement = Get.find();

  @override
  Widget build(BuildContext context) {
    final Rx<Duration> currentPosition = myAudioPlayer.position;
    return Container(
      height: 250.r,
      width: 500.r,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Image.asset(
              'assets/images/background/player.png',
              width: 150.r,
              height: 150.r,
              cacheHeight: 300,
              cacheWidth: 300,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 20.h),
              _buildProgressBar(currentPosition),
              _buildTimeLabels(currentPosition),
              SizedBox(height: 10.h),
              BuildControlBt(
                player: myAudioPlayer.player,
              ),
              Obx(() {
                final data = myAudioPlayer.episodeData.value;
                if (data != null) {
                  return Extras(
                    episodeData: data,
                    icon: const Icon(Icons.menu),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
            ],
          ).asGlass(
            blurX: 1,
            blurY: 1,
            tintColor: Theme.of(context).colorScheme.surface,
            clipBorderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
        ],
      ),
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
}
