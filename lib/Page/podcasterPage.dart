import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';
import 'package:podivy/model/Episode.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/service/search/searchService.dart';
import 'package:podivy/widget/drawer.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev show log;

class PodcasterPage extends StatelessWidget {
  PodcasterPage({super.key});
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final Podcaster podcaster =
      Podcaster(id: Get.arguments); //Get.arguments => catch podcaster id
  final RxBool openedDescription = false.obs;

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
                    Obx(() => _buildProfileInformation(context, data)),
                    _buildEpisodesSection(episodeList, data),
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

  Widget _buildProfileInformation(
      BuildContext context, Podcaster podcasterData) {
    final RxDouble profileHeight =
        openedDescription.value ? 500.h.obs : 220.h.obs;
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            podcasterData.imageUrl!,
            fit: BoxFit.cover,
            height: 300.h,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 0).r,
          child: AnimatedContainer(
            height: profileHeight.value,
            duration: const Duration(milliseconds: 200),
            color: Colors.black45,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 35.r,
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                    IconButton(
                      iconSize: 35.r,
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_sharp),
                    ),
                  ],
                ),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    openedDescription.value =
                        openedDescription.value ? false : true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5).r,
                    child: Row(
                      children: [
                        _buildUserAvatar(podcasterData.imageUrl!),
                        SizedBox(
                          width: 15.w,
                        ),
                        Flexible(
                          child: _buildTitleTextScroll(podcasterData.title),
                        ),
                        SizedBox(
                          width: 25.w,
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).asGlass(
            clipBorderRadius: BorderRadius.circular(30),
          ),
        )
      ],
    );
  }

  Widget _buildUserAvatar(String imageUrl) {
    return UserAvatar(
      imgPath: imageUrl,
      radius: 60,
      borderThickness: 65,
      isNetwork: true,
      color: const Color(0xFFABC4AA),
    );
  }

  Widget _buildTitleTextScroll(String? title) {
    return TextScroll(
      title ?? 'Unknown Title',
      style: TextStyle(
        fontSize: ScreenUtil().setSp(20),
      ),
      intervalSpaces: 5,
      velocity: const Velocity(pixelsPerSecond: Offset(60, 0)),
      delayBefore: const Duration(seconds: 3),
      pauseBetween: const Duration(seconds: 10),
      fadedBorder: true,
    );
  }

  Widget _buildEpisodesSection(
      List<Episode>? getEpisodes, Podcaster podcasterDate) {
    if (getEpisodes == null) {
      return const Expanded(child: Text("無內容"));
    }
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7B7060),
              Color(0xFF2C271D),
            ],
            stops: [0.7, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).r,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      print('sort');
                    },
                    icon: const Icon(Icons.sort_sharp),
                  ),
                  Text('${getEpisodes.length} 部'),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              _buildEpisodesList(getEpisodes, podcasterDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesList(
      List<Episode>? getEpisodes, Podcaster podcasterDate) {
    return Expanded(
      child: ListView.builder(
        key: UniqueKey(),
        padding: EdgeInsets.zero,
        itemCount: getEpisodes!.length,
        itemBuilder: (BuildContext context, int index) {
          final Episode getEpisode = getEpisodes[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).h,
            child: ListTile(
              title: Text(
                getEpisode.title,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                Get.toNamed("/player", arguments: {
                  'podcaster': podcasterDate,
                  'episodes': getEpisodes,
                  'index': index
                });
              },
            ),
          );
        },
      ),
    );
  }
}
