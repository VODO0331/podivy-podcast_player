import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/Page/common/podcasterPage/build/buildEpisodesSection.dart';
import 'package:podivy/Page/common/podcasterPage/build/buildProfileInformation.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/service/search/singlePodcastService.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;


class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final Podcaster podcaster =
      Podcaster(id: Get.arguments); //Get.arguments => catch podcaster id

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != 0 && details.primaryDelta! > 10) {
          sKey.currentState?.openDrawer();
        }
      },
      child: Scaffold(
          key: sKey,
          drawer: const MyDrawer(),
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
          )),
    );
  }
}
