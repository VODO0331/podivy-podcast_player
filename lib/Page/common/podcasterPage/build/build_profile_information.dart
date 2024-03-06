import 'package:flutter/material.dart';
import 'package:followed_management/followed_management.dart';

import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Controller/widget_animation_controller.dart';
import 'package:search_service/search_service_repository.dart';

// import 'dart:developer' as dev show log;

class ProfileInformation extends StatefulWidget {
  final Podcaster podcasterData;
  const ProfileInformation({super.key, required this.podcasterData});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final _widgetController = Get.put(WidgetController());
  final RxBool isFollowed = false.obs;
  late FollowedManagement _followedStorageService;
  @override
  void initState() {
    super.initState();
    _followedStorageService = FollowedManagement();
  }

  @override
  void dispose() {
    super.dispose();
    _followedStorageService;
    _widgetController;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildShaderMask(widget.podcasterData.imageUrl!),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 60, 15, 0).r,
            child: AnimatedBuilder(
              animation: _widgetController.animationController!,
              builder: (context, child) {
                return Container(
                  height: _widgetController.heightAnimation!.value.h,
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
                          _widgetController.changeAnimation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildUserAvatar(
                                widget.podcasterData.imageUrl!,
                                _widgetController.avatarSizeAnimation!.value,
                                _widgetController.opacityAnimation!.value!,
                              ),
                              Flexible(
                                child: _buildTitleTextScroll(
                                  widget.podcasterData.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildDescription(
                          widget.podcasterData,
                          _widgetController.opacityAnimation!.value!,
                          isFollowed,
                          _followedStorageService,
                        ),
                      ),
                      Transform.rotate(
                        angle: _widgetController.rotateAnimation!.value,
                        child: GestureDetector(
                          onTap: () {
                            _widgetController.changeAnimation();
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
  Podcaster podcasterData,
  double opacity,
  RxBool isFollowed,
  FollowedManagement followedStorageService,
) {
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
                  future: followedStorageService.isFollowed(podcasterData.id),
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
                              followedStorageService,
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
                      return OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(
                            ScreenUtil().setWidth(150),
                            ScreenUtil().setWidth(40),
                          ),
                        ),
                        onPressed: null,
                        icon: const Icon(Icons.favorite_border),
                        label: const Text("追隨"),
                      );
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
  FollowedManagement followedController,
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
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholderCacheWidth: 90,
              placeholderCacheHeight: 90,
              imageCacheHeight: 160,
              imageCacheWidth: 160,
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
              placeholder: "assets/images/generic/search_loading.gif",
              image: imageUrl,
              imageErrorBuilder: (context, _, __) {
                return Image.asset(
                  "assets/images/podcaster/defaultPodcaster.jpg",
                  fit: BoxFit.cover,
                  cacheHeight: 100,
                  cacheWidth: 100,
                );
              },
            ),
          ),
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
