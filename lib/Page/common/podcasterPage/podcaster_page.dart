import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart' show Episode,Podcaster;
import 'package:podivy/Page/common/podcasterPage/build/build_episodes_list.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_profile_information.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final String podcasterId =
      Get.arguments; //Get.arguments => catch podcaster id

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Theme.of(Get.context!).colorScheme.background
            : Theme.of(Get.context!).colorScheme.secondaryContainer,
        key: sKey,
        resizeToAvoidBottomInset:false,
        body: FutureBuilder(
            future: getSinglePodcasterData(
              id: podcasterId
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  dev.log(snapshot.error.toString());
                  return Text('snapshot Error:${snapshot.error}');
                }
                final Podcaster? data = snapshot.data;
                if (data == null) {
                  return Center(
                    child: Text(
                      'dataNotFind'.tr,
                      style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                    ),
                  );
                }
                List<Episode>? episodeList = data.episodesList;
                return Column(
                  children: [
                    ProfileInformation(podcasterData: data),
                    EpisodesSection(
                        getEpisodes: episodeList, podcasterDate: data),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
  }
}
