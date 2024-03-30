import 'package:firestore_service_repository/firestore_service_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
// import 'package:podivy/util/dialogs/cannot_play.dart';
import 'package:podivy/widget/extras.dart';
import 'package:provider/provider.dart';

import 'build_control_bt.dart';

class PlayerControl extends StatelessWidget {
  // final MyAudioPlayer myAudioPlayer;
  PlayerControl({
    super.key,
    // required this.myAudioPlayer,
  });
  final ListManagement listManagement = Get.find();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAudioPlayer>(builder: (context, value, child) {
      final Rx<Duration> currentPosition = value.position;
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
                cacheHeight: 300.r.toInt(),
                cacheWidth: 300.r.toInt(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  Get.isDarkMode
                      ? 'assets/images/podchaser/bow.png'
                      : 'assets/images/podchaser/wob.png',
                  height: 30.r,
                  width: 170.r,
                  cacheHeight: 30.r.toInt(),
                  cacheWidth: 170.r.toInt(),
                  fit: BoxFit.cover,
                ),
                Obx(
                  () => Slider(
                    value: currentPosition.value.inSeconds.toDouble(),
                    min: 0,
                    max: value.duration.value.inSeconds.toDouble(),
                    onChanged: (va) async {
                      //
                      currentPosition.value = Duration(seconds: va.toInt());
                      await value.seek(value.position.value);
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24).w,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(currentPosition.value)),
                          Text(formatTime(value.duration.value)),
                        ],
                      ),
                    )),
                SizedBox(height: 10.h),
                const BuildControlBt(
                    // player: myAudioPlayer.player,
                    ),
                Obx(() {
                  final data = value.episodeData.value;
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
    });
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
