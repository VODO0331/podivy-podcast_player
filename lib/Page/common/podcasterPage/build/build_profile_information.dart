import 'package:flutter/material.dart';
import 'package:followed_management_service/followed_management.dart';

import 'package:get/get.dart';
import 'package:interests_management_service/interests.management.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Controller/widget_animation_controller.dart';
import 'package:podivy/Page/common/podcasterPage/build/build_description.dart';
import 'package:search_service/search_service_repository.dart';



class ProfileInformation extends StatelessWidget {
  final Podcaster podcasterData;
  ProfileInformation({super.key, required this.podcasterData});
  final _widgetController = Get.put(WidgetController());
  final RxBool isFollowed = false.obs;
  final FollowedManagement _followedStorageService =
      Get.put(FollowedManagement());
  // final InterestsManagement _interestsManagement = Get.find();
   final InterestsManagement _interestsManagement =
      Get.put(InterestsManagement());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildShaderMask(podcasterData.imageUrl!),
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
                                podcasterData.imageUrl!,
                                _widgetController.avatarSizeAnimation!.value,
                                _widgetController.opacityAnimation!.value!,
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
                        child: ShowDescription(
                            podcasterData: podcasterData,
                            opacity: _widgetController.opacityAnimation!.value!,
                            isFollowed: isFollowed,
                            followedManagement: _followedStorageService,
                            interestsManagement: _interestsManagement),
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

Future<void> changeBtState(
  FollowedManagement followedController,
  InterestsManagement interestsManagement,
  Podcaster podcasterData,
  bool value,
) async {
  if (value) {
    await followedController.deleteFollowed(podcastId: podcasterData.id);
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  } else {
    await followedController.addFollowed(
      podcastId: podcasterData.id,
      podcastImg: podcasterData.imageUrl,
      podcastName: podcasterData.title,
    );
    await interestsManagement.updateInterests(podcasterData.categories, !value);
  }
}

Widget _buildUserAvatar(String imageUrl, double size, double opacity) {
  return Visibility(
    visible: size > 0,
    child: Opacity(
      opacity: 1 - opacity,
      child: Padding(
        padding: const EdgeInsets.only(right: 20).r,
        child: SizedBox(
          height: size * 2,
          width: size * 2,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: const CircleBorder(),
            color: Colors.transparent,
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


