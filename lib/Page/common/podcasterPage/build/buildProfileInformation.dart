
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:podivy/Controller/WidgetController.dart';
import 'package:podivy/model/Podcaster.dart';
import 'package:podivy/service/cloud/followed/firebaseCloudStroge.dart';
import 'package:podivy/widget/userAvatar.dart';
import 'package:text_scroll/text_scroll.dart';

// import 'dart:developer' as dev show log;

class ProfileInformation extends StatelessWidget {
  final Podcaster podcasterData;
  const ProfileInformation({super.key, required this.podcasterData});

  @override
  Widget build(BuildContext context) {
    Get.create(() => WidgetController());
    final WidgetController widgetController = Get.find();
    final RxBool isFollowed = false.obs;
    return Stack(
      children: [
        _buildShaderMask(podcasterData.imageUrl!),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 60, 15, 0).r,
            child: AnimatedBuilder(
              animation: widgetController.animationController!,
              builder: (context, child) {
                return Container(
                  height: widgetController.heightAnimation!.value.h,
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
                            icon: const Icon(Icons.arrow_back_rounded),
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
                          widgetController.changeAnimation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildUserAvatar(
                                podcasterData.imageUrl!,
                                widgetController.avatarSizeAnimation!.value,
                                widgetController.opacityAnimation!.value!,
                              ),
                              Flexible(
                                child: _buildTitleTextScroll(
                                  podcasterData.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildDescription(
                            podcasterData,
                            widgetController.opacityAnimation!.value!,
                            isFollowed),
                      ),
                      Transform.rotate(
                        angle: widgetController.rotateAnimation!.value,
                        child: GestureDetector(
                          onTap: () {
                            widgetController.changeAnimation();
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 30.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).asGlass(
                  clipBorderRadius: BorderRadius.circular(30),
                );
              },
            ))
      ],
    );
  }
}

Widget _buildDescription(
    Podcaster podcasterData, double opacity, RxBool isFollowed) {
  final _followedStorageService = Get.put(PodcastFollowedStorage());

  return Opacity(
    opacity: opacity,
    child: Visibility(
      visible: opacity > 0.75,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(
                        ScreenUtil().setWidth(150), ScreenUtil().setWidth(40)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text("分享"),
                ),
                FutureBuilder(
                  future: _followedStorageService.isFollowed(podcasterData.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      isFollowed.value = snapshot.data!;

                      return Obx(() {
                        final Rx<IconData> btIcon = isFollowed.value
                            ? Icons.favorite.obs
                            : Icons.favorite_border.obs;
                        final Rx<Color> btColor = isFollowed.value
                            ? Colors.red.obs
                            : Colors.white.obs;
                        return OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              fixedSize: Size(
                                ScreenUtil().setWidth(150),
                                ScreenUtil().setWidth(40),
                              ),
                              foregroundColor: btColor.value,
                              side: BorderSide(color: btColor.value)),
                          onPressed: () async {
                            await changeBtState(
                              _followedStorageService,
                              podcasterData,
                              isFollowed.value,
                            );
                            isFollowed.value = !isFollowed.value;
                          },
                          icon: Icon(
                            btIcon.value,
                            color: btColor.value,
                          ),
                          label: const Text("追隨"),
                        );
                      });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            // SizeTransition(sizeFactor: ,)
            Expanded(
              child: SingleChildScrollView(
                child: Text(podcasterData.description!),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> changeBtState(
  PodcastFollowedStorage followedController,
  Podcaster podcasterData,
  bool value,
) async {
  if (value) {
    await followedController.deleteFollowed(podcastId: podcasterData.id);
  } else {
    await followedController.addFollowed(
      podcastId: podcasterData.id,
      podcastImg: podcasterData.imageUrl,
      podcastName: podcasterData.title,
    );
    // await followedController.deleteFollowed(podcastId: podcasterData.id);
  }
}

Widget _buildUserAvatar(String imageUrl, double size, double opacity) {
  return Visibility(
    visible: size > 0,
    child: Opacity(
      opacity: 1 - opacity,
      child: Padding(
        padding: const EdgeInsets.only(right: 20).r,
        child: UserAvatar(
          imgPath: imageUrl,
          radius: size,
          borderThickness: size + 5,
          isNetwork: true,
          color: const Color(0xFFABC4AA),
        ),
      ),
    ),
  );
}

Widget _buildTitleTextScroll(
  String? title,
) {
  return TextScroll(
    title ?? 'Unknown Title',
    style: TextStyle(
      fontSize: ScreenUtil().setSp(20),
    ),
    intervalSpaces: 5,
    velocity: const Velocity(pixelsPerSecond: Offset(65, 0)),
    delayBefore: const Duration(seconds: 3),
    pauseBetween: const Duration(seconds: 10),
    fadedBorder: true,
  );
}

Widget _buildShaderMask(String imageUrl) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.transparent],
      ).createShader(bounds);
    },
    blendMode: BlendMode.dstIn,
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 300.h,
      width: double.infinity,
    ),
  );
}
