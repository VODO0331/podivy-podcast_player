import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Page/personal/playerPage/build/build_player_control.dart';
import 'package:provider/provider.dart';

import 'build/build_episode_info.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
     
    return Consumer<MyAudioPlayer>(
      builder: (context, value, child) {
      
        final AudioPlayer audioPlayer = value.player;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: DefaultTextStyle(
                style: GoogleFonts.mulish(
                  color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    shadows: [
                       Shadow(
                        blurRadius: 7.0,
                        color: Theme.of(context).colorScheme.primary,
                        offset: const Offset(0, 0),
                      )
                    ]),
                child: AnimatedTextKit(animatedTexts: [
                  FlickerAnimatedText(
                    'Player',
                  ),
                  FlickerAnimatedText(
                    'Podcast',
                  ),
                ],repeatForever :true),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: audioPlayer.sequenceStateStream,
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
                PlayerControl(),
              ],
            ));
      },
    );
  }
}
