import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_episodes_section.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_profile_information.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

import 'package:search_service/search_service_repository.dart';

class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final Podcaster podcaster =
      Podcaster(id: Get.arguments); //Get.arguments => catch podcaster id

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: sKey,
          body: FutureBuilder(
            future: getSinglePodcasterData(podcaster),
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
                      '顯示錯誤',
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
          ));
    
  }
}
